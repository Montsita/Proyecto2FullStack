async function cargarArchivoDesdeDB() {
    try {
        const response = await fetch("/api/projects");
        if (!response.ok) {
            throw new Error("Error al cargar los datos de la base de datos");
        }

        const destinations = await response.json();
        const idDestinations = destinations.map((destination)=>destination.id)

        const sectionDestinations = document.querySelector(".experience");
        
        let currentIndex = 0;

        function displayDestination(index) {
            const destination = destinations[index];
            sectionDestinations.innerHTML = `
                <a id="link1" href="http://127.0.0.1:5000/details_destination/${destination.id}">
                  <div class="exp">  
                      <img id="img1" src="static/img/${destination.name}.jpg" alt="image">
                      <h3 id="title1">${destination.name}</h3>
                      <h4 id="subTitle1">${destination.country}</h4>
                      <p id="subTitle2">${destination.MainAttractions}</p>
                  </div>
                </a>
            `;
        }

        //Muestro el primer destino
        displayDestination(currentIndex);
        
        function showNextDestination() {
            currentIndex = (currentIndex + 1) % destinations.length; 
            displayDestination(currentIndex);
        }

        function showPrevDestination() {
            currentIndex = (currentIndex - 1 + destinations.length) % destinations.length; // Retrocede al destino anterior
            displayDestination(currentIndex);
        }

        //avance automático cada 30 segundos
        setInterval(showNextDestination, 30000);

        document.querySelector("#prevExpBtn").addEventListener("click", showPrevDestination);
        document.querySelector("#nextExpBtn").addEventListener("click", showNextDestination);

        // Carousel
    } catch (error) {
        console.error("Hubo un problema con la petición fetch:", error);
    }
}

cargarArchivoDesdeDB();