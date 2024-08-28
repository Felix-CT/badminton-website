// callAPI function that takes the base and exponent numbers as parameters
var callAPI = (requestType, newLimit=null)=>{
    // instantiate a headers object
    var myHeaders = new Headers();
    // add content type header to object
    myHeaders.append("Content-Type", "application/json");

    apiUrl = "https://nyia4b53xa.execute-api.us-east-2.amazonaws.com/Dev";
    // using built in JSON utility package turn object to string and store in a variable
    if (newLimit === null){
        var requestOptions = {
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
        var requestOptions = {
        method: requestType,
        headers: myHeaders,
        body: JSON.stringify({"newLimit":newLimit}),
        redirect: 'follow'
        };

        // make API call with parameters and use promises to get response
        fetch(apiUrl, requestOptions)
        .then(response => response.text())
        .then(guestListUpdateSuccess())
        .catch(error => console.log('error', error));
}
    };

    // create a JSON object with parameters for API call and store in a variable
    var requestOptions = {
        method: requestType,
        headers: myHeaders,
        body: raw,
        redirect: 'follow'
    };
    

var getGuestLimit = ()=>{
    return callAPI('GET');
}


//Code to retrieve value from the database
document.getElementById("guests-count").addEventListener('load', async function(e) {
    document.getElementById("guests-count").value = getGuestLimit();
});