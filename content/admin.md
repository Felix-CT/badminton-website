---
title: "Administrator tools"
tags: ""
draft: false
---


<h1>Administrator Tools</h1>

<form id="admin-form">
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>
    <br><br>
</form>

<label for="guests">Set Number of Guests Allowed:</label>
<input type="number" id="guests" name="guests" required>
<br><br>

<button type="submit">Update</button>
<p id="message"></p>

<script src="admin.js"></script>