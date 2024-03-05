//Java Code

const counter = document.querySelector('.counter-number');

async function updateCounter() {
    try {
        let response = await fetch("https://xkpruvizvvpkh3bcuapsmrddly0gzlpo.lambda-url.us-west-2.on.aws/");
        let data = await response.json();
        counter.innerHTML = `Views: ${data.views}`;
    } catch (error) {
        console.error('Error fetching data:', error);
    }
}

updateCounter();

