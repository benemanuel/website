"use strict";

let submit = document.getElementById("search-query");
submit.addEventListener("keydown", function(even) {
    if (event.key !== "Enter") {
        return;
    }
    let params = new URLSearchParams();
    let query = document.getElementById("search-query");
    params.set("s", query.value);
    window.location.href = "/search?" + params;
    event.preventDefault();
});