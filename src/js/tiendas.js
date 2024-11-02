/**
 * @description Hace uso de la API de LeafletJS para crear mapas interactivos de las diferentes tiendas
 */
// Mapa 1
var map1 = L.map('map1').setView([37.21311017548976, -3.6149235141018696], 12); // Mercadona

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map1);
L.marker([37.21311017548976, -3.6149235141018696]).addTo(map1).bindPopup('Mapa 1: Mercadona');

// Mapa 2
var map2 = L.map('map2').setView([37.17505247806386, -3.5946676697269724], 12); // JD

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map2);
L.marker([37.17505247806386, -3.5946676697269724]).addTo(map2).bindPopup('Mapa 2: JD');

// Mapa 3
var map3 = L.map('map3').setView([37.21619736082923, -3.6087439584563494], 12); // Burguer King

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map3);
L.marker([37.21619736082923, -3.6087439584563494]).addTo(map3).bindPopup('Mapa 3: Burguer King');
