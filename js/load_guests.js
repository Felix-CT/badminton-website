// callAPI function that takes the base and exponent numbers as parameters
var callAPI = (requestType) => {
    // Instantiate a headers object
    var myHeaders = new Headers();
    // Add content type header to object
    myHeaders.append("Content-Type", "application/json");

    const apiUrl = "https://nyia4b53xa.execute-api.us-east-2.amazonaws.com/Dev";

    const requestOptions = {
        method: requestType,
        headers: myHeaders,
        redirect: 'follow'
    };

    return fetch(apiUrl, requestOptions)
        .then(response => response.json())  // Parse JSON response
        .then(result => {
            if (result.body) {
                return result.body; 
            } else {
                alert('No data found');
                return null;
            }
        })
        .catch(error => {
            console.log('error', error);
            return null;
        });
};

var getGuestLimit = async () => {
    return await callAPI('GET');
};

async function fetchGuestData() {
    const guestLimit = await getGuestLimit(); // Replace with your API endpoint
    if (guestLimit !== null) {
        sessionStorage.setItem('guestLimit', guestLimit);
    } else {
        console.error('Failed to fetch guest data');
    }
}

// Fetch and store the guest data when the website is loaded
window.onload = async () => {
    if (!sessionStorage.getItem('guestData')) {
        await fetchGuestData();
    }
};