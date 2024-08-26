---
title: "Waitlist"
tags: ""
draft: false
---

<h1>Guests Allowed This Week</h1>

<p id="guests-count">Loading...</p>

<script>
    // Load the number of guests from localStorage (can be replaced with a backend call)
    const guests = localStorage.getItem('numberOfGuests');
    document.getElementById('guests-count').textContent = guests ? guests : 'Not Set';
</script>