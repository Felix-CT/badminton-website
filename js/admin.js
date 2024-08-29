// callAPI function that takes the base and exponent numbers as parameters
var callAPI = (requestType, newLimit=null)=>{
    // instantiate a headers object
    var myHeaders = new Headers();
    // add content type header to object
    myHeaders.append("Content-Type", "application/json");

    const apiUrl = "https://nyia4b53xa.execute-api.us-east-2.amazonaws.com/Dev";
    // using built in JSON utility package turn object to string and store in a variable
    if (newLimit === null){
        const requestOptions = {
            method: requestType,
            headers: myHeaders,
            redirect: 'follow'
        };

        fetch(apiUrl, requestOptions)
        .then(response => response.json())  // Parse JSON response
        .then(result => {
            if (result.body) {
                return result.body; 
            } else {
                alert('No data found');
            }
        })
        .catch(error => console.log('error', error));
    } else {
        const requestOptions = {
        method: requestType,
        headers: myHeaders,
        body: JSON.stringify({"newLimit":newLimit}),
        redirect: 'follow'
        };

        // make API call with parameters and use promises to get response
        fetch(apiUrl, requestOptions)
        .then(response => response.text())
        .then(guestListUpdateSuccess)
        .catch(error => console.log('error', error));
    }
};



var getGuestLimit = ()=>{
    return callAPI('GET');
}

var updateGuestLimit = (newLimit)=>{
    callAPI('POST', newLimit)
}

var guestListUpdateSuccess = ()=>{
    const messageElement = document.getElementById('message');
    messageElement.textContent = 'Number of guests updated successfully!';
    messageElement.style.color = 'green';
}

document.getElementById('password-form').addEventListener('submit', function(e) {
    e.preventDefault();
    

    const password = document.getElementById('password').value;
    const messageElement = document.getElementById('message');
    const guestForm = document.getElementById('guest-form');

    // Simple password validation
    if (password === 'test') {
        // Hide the password form and show the guest form
        document.getElementById('password-form').style.display = 'none';
        guestForm.style.display = 'block';
        messageElement.textContent = '';
    } else {
        messageElement.textContent = 'Invalid password!';
        messageElement.style.color = 'red';
    }
});

document.getElementById('guest-form').addEventListener('submit', function(e) {
    e.preventDefault();

    const newLimit = document.getElementById('guests').value;
    const messageElement = document.getElementById('message');

    // Save the number of guests to localStorage (can be replaced with a backend call)
    updateGuestLimit(newLimit);
    messageElement.textContent = 'Number of guests updated successfully!';
    messageElement.style.color = 'green';
});





//Code to retrieve value from the database
document.getElementById('guest-form').addEventListener('load', async function(e) {
    document.getElementById('guest-form').value = getGuestLimit();
});