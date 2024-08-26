---
title: "Administrator tools"
tags: ""
draft: false
---

<h1>Administrator Tools</h1>

<!-- Password Form -->
<form id="password-form">
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>
    <br><br>
    <button type="submit">Login</button>
</form>

<!-- Guest Input Form (Initially Hidden) -->
<form id="guest-form" style="display:none;">
    <label for="guests">Set Number of Guests Allowed:</label>
    <input type="number" id="guests" name="guests" required>
    <br><br>
    <button type="submit">Update</button>
</form>

<!-- Message Display -->
<p id="message"></p>

<script src="/js/admin.js"></script>
