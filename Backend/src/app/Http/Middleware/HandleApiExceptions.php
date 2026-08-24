<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Closure;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Throwable;

final class HandleApiExceptions
{
    /**
     * @param  Closure(Request): Response  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            return $next($request);
        } catch (HttpResponseException $exception) {
            return $exception->getResponse();
        } catch (AuthenticationException) {
            return $this->error('Token tidak valid atau sesi telah berakhir.', Response::HTTP_UNAUTHORIZED);
        } catch (AuthorizationException) {
            return $this->error('Anda tidak memiliki izin untuk melakukan tindakan ini.', Response::HTTP_FORBIDDEN);
        } catch (ModelNotFoundException) {
            return $this->error('Data yang diminta tidak ditemukan.', Response::HTTP_NOT_FOUND);
        } catch (ValidationException $exception) {
            return response()->json([
                'success' => false,
                'message' => 'Data yang diberikan tidak valid.',
                'errors' => $exception->errors(),
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        } catch (HttpExceptionInterface $exception) {
            $status = $exception->getStatusCode();

            return $this->error($this->messageForStatus($status), $status, $exception->getHeaders());
        } catch (Throwable $exception) {
            report($exception);

            return $this->error(
                config('app.debug')
                    ? $exception->getMessage()
                    : 'Terjadi kesalahan pada server. Silakan coba kembali.',
                Response::HTTP_INTERNAL_SERVER_ERROR,
            );
        }
    }

    /**
     * @param  array<string, string>  $headers
     */
    private function error(string $message, int $status, array $headers = []): Response
    {
        return response()->json([
            'success' => false,
            'message' => $message,
        ], $status, $headers);
    }

    private function messageForStatus(int $status): string
    {
        return match ($status) {
            Response::HTTP_NOT_FOUND => 'Endpoint atau data tidak ditemukan.',
            Response::HTTP_METHOD_NOT_ALLOWED => 'Metode HTTP tidak diizinkan.',
            Response::HTTP_TOO_MANY_REQUESTS => 'Terlalu banyak permintaan. Silakan coba kembali nanti.',
            Response::HTTP_UNPROCESSABLE_ENTITY => 'Data yang diberikan tidak valid.',
            default => 'Permintaan tidak dapat diproses.',
        };
    }
}
