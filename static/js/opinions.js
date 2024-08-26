const opinions = [
    {
        "name": "Juan Pérez",
        "destination": "New York",
        "opinion": "The experience was incredible, the service was impeccable, and the destinations were dreamy. Highly recommended!",
        "date": "August 15, 2024"
    },
    {
        "name": "Ana Gómez",
        "destination": "Rome",
        "opinion": "I had one of the best vacations of my life, everything was well organized and the guides were very friendly.",
        "date": "July 10, 2024"
    },
    {
        "name": "Luis Rodríguez",
        "destination": "Sydney",
        "opinion": "I loved the adventure and the variety of activities we could do. I would definitely travel with them again!",
        "date": "June 22, 2024"
    },
    {
        "name": "Marta Sánchez",
        "destination": "Paris",
        "opinion": "The trip was spectacular, it exceeded all my expectations. Customer service was excellent.",
        "date": "May 5, 2024"
    },
    {
        "name": "Carlos Fernández",
        "destination": "Tokyo",
        "opinion": "An unforgettable experience, the destinations were amazing, and the service was top-notch.",
        "date": "April 30, 2024"
    }
];

const sectionOpinions = document.querySelector(".carusel-opinions");

let currentIndex = 0;

function displayOpinion(index) {
    const opinion = opinions[index];
    sectionOpinions.innerHTML = `
          <div class="opinions">  
              <h4 id="title1">${opinion.name}</h4>
              <h4 id= "destination1">${opinion.destination}</h4>
              <p id="subTitle1">${opinion.opinion}</p>
              <p id="subTitle2">${opinion.date}</p>
          </div>
    `;
}

//Muestro el primer destino
displayOpinion(currentIndex);
        
function showNextOpinion() {
    currentIndex = (currentIndex + 1) % opinions.length; 
    displayOpinion(currentIndex);
}

function showPrevOpinion() {
    currentIndex = (currentIndex - 1 + opinions.length) % opinions.length; 
    displayOpinion(currentIndex);
}

//avance automático cada 30 segundos
setInterval(showNextOpinion, 30000);

document.querySelector("#prevOpiBtn").addEventListener("click", showPrevDestination);
document.querySelector("#nextOpiBtn").addEventListener("click", showNextDestination);