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

    const guests = document.getElementById('guests').value;
    const messageElement = document.getElementById('message');

    // Save the number of guests to localStorage (can be replaced with a backend call)
    localStorage.setItem('numberOfGuests', guests);
    messageElement.textContent = 'Number of guests updated successfully!';
    messageElement.style.color = 'green';
});
