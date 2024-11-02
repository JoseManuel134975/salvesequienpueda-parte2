/**
 * 
 * @param {string} user 
 * @param {string} pass
 * 
 * @description Simula el inicio de sesión para cualquier usuario que esriba un nombre y contraseña
 * Usa POO para crear el usuario y después mostrar sus propiedades mediante una alerta
 * 
 * @example iniciarSesion('pedro', '1234') alert('Bienvenido pedro. Tu clave es 1234')
 */
const iniciarSesion = (user, pass) => {
    const usuario = {
        nombre: user,
        clave: pass
    }

    alert(`Bienvenido ${usuario.nombre}. Tu clave es '${usuario.clave}'`)
}