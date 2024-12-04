// Custom promise-based setTimeout implementation
const setTimeoutPromise = (ms) => new Promise(resolve => setTimeout(resolve, ms));

// Code to retrieve value from the database
document.addEventListener('DOMContentLoaded', async function() {
    let guestLimit = sessionStorage.getItem('guestLimit');
    while (!guestLimit){
        await setTimeoutPromise(1000);
        guestLimit = sessionStorage.getItem('guestLimit')
    }

    document.getElementById("guests-count").innerText = 'Current guest limit is ' + guestLimit;
    console.log(guestLimit)
    const guestsMessage = document.getElementById("guests-message")
    if (guestLimit > 0) {
        guestsMessage.innerText = "There is space available! Please message bellbclub@gmail.com to join us this week.";
        guestsMessage.style.color = 'green'
    } else {
        guestsMessage.innerText = "Unfortunately there are no more spots available. Please check again later as spots may open up.\n A total of two guests are allowed per week."
        guestsMessage.style.color = 'red'
    }
});
