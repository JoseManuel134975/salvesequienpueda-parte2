<?php
use PHPUnit\Framework\TestCase;

// Incluir el archivo donde se define la función
require_once './src/php/sayHello.php'; // Ajusta esta ruta según tu estructura de archivos

class SayHelloTest extends TestCase
{
    public function testSayHello()
    {
        // Iniciar el almacenamiento de la salida
        ob_start();
        
        // Llamar a la función
        sayHello();
        
        // Obtener la salida capturada
        $output = ob_get_clean();
        
        // Verificar que la salida es la esperada
        $this->assertEquals('Hello!', $output);
    }
}
