/**
 * @description Inicializa un mapa de Leaflet en una ubicación específica y añade un marcador con un popup.
 * @param {string} idMapa - El ID del contenedor del mapa.
 * @param {Array<number>} coordenadas - Las coordenadas [lat, lng] para centrar el mapa.
 * @param {string} mensajePopup - El texto que aparecerá en el popup del marcador.
 * Comentario extra *2 *3
 */
function inicializarMapa(idMapa, coordenadas, mensajePopup) {
    var map = L.map(idMapa).setView(coordenadas, 12);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    L.marker(coordenadas).addTo(map).bindPopup(mensajePopup);
}

// Uso de la función para inicializar los mapas
inicializarMapa('map1', [37.21311017548976, -3.6149235141018696], 'Mapa 1: Mercadona');
inicializarMapa('map2', [37.17505247806386, -3.5946676697269724], 'Mapa 2: JD');
inicializarMapa('map3', [37.21619736082923, -3.6087439584563494], 'Mapa 3: Burguer King');
