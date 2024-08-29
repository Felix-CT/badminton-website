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

// Code to retrieve value from the database
document.addEventListener('DOMContentLoaded', async function() {
    const guestLimit = await getGuestLimit();
    if (guestLimit !== null) {
        document.getElementById("guests-count").innerText = guestLimit;
    }
});
