"use strict";

setupPage();

function setupPage() {
    let params = new URLSearchParams(window.location.search);
    let search = params.get("s");
    let page = Number(params.get("p"));
    if (page == 0 || page == NaN || page == Infinity) {
        page = 1;
    }
    page = Math.floor(page);

    if (search) {
        // Put the query into the title so we know what was searched
        let title = document.getElementById("search-title");
        title.innerText = "Search Results for: ";
        let query_span = document.createElement("span");
        query_span.classList.add("text-muted");
        query_span.classList.add("search-query-text");
        query_span.innerText = search;
        title.appendChild(query_span);

        // Pull the search results from the server and display them
        runSearch(search, page);
    } else {
        populateNavNoPages();
    }
}

async function runSearch(search, page)
{
    if (runSearch.tries === undefined) {
        runSearch.tries = 0;
    }

    page = page || 1;

    let params = new URLSearchParams();
    params.set("s", search);
    params.set("p", page);

    // fetch the results
    let results = null;
    try {
        let response = await fetch("https://search.nachtimwald.com/?" + params);
        results = await response.json();
    } catch (e) {
        // Retry a few times in case of a hiccup.
        if (runSearch.tries >= 3) {
            populateSearchError();
            return;
        }

        runSearch.tries++;
        setTimeout(runSearch, 250, search, page);
        return;
    }

    if (!results || results.pages == 0) {
        populateNoResults();
        populateNavNoPages()
    } else {
        populateResults(search, results.hits);
        populateNav(search, results.page, results.pages)
    }
}

function populateSearchError()
{
    // Set the no text
    let entry = document.createElement("div");
    entry.innerText = "Search Failed";
    let view = document.getElementById("results");
    view.appendChild(entry);
}

function populateNoResults()
{
    // Set the no text
    let entry = document.createElement("div");
    entry.innerText = "No results";
    let view = document.getElementById("results");
    view.appendChild(entry);
}

function generate_nav_item(text, href, active, disabled) {
    let nav_link = document.createElement("a");
    nav_link.classList.add("page-link");
    nav_link.href = href;
    nav_link.innerText = text;
    let nav_item = document.createElement("li");
    nav_item.classList.add("page-item");
    if (active) {
        nav_item.classList.add("active");
        nav_link.href = "#";
    }
    if (disabled) {
        nav_item.classList.add("disabled");
    }
    nav_item.appendChild(nav_link);
    return nav_item;
}

function populateNavNoPages()
{
    let page_nav = document.getElementById("nav_pages");
    page_nav.appendChild(generate_nav_item("First", "#", false, true));
    page_nav.appendChild(generate_nav_item("1", "1", true, false));
    page_nav.appendChild(generate_nav_item("Last", "#", false, true));
}

function populateResults(search, results)
{
    let view = document.getElementById("results");
    for (let result of results) {
        let article = document.createElement("article");
        article.classList.add("post-preview-box");
        let h1 = document.createElement("h1");
        h1.classList.add("post-title");
        h1.classList.add("title-text");
        let link = document.createElement("a");
        link.href = result.uri;
        link.innerText = result.title
        h1.appendChild(link);
        article.appendChild(h1);

        if (result.post_date) {
            let date_span = document.createElement("span");
            date_span.classList.add("post-meta");
            date_span.classList.add("entry-date");
            date_span.classList.add("text-muted");
            date_span.innerText = result.post_date;

            article.appendChild(date_span);
        }

        article.appendChild(document.createElement("br"));
        article.appendChild(document.createElement("br"));

        let preview = document.createElement("div");
        preview.classList.add("post-preview-content");
        preview.innerText = `${result.excerpt}... `;

        let continue_link = document.createElement("a");
        continue_link.classList.add("readMoreLink");
        continue_link.href = result.uri
        continue_link.innerText = "Continue reading";
        preview.appendChild(continue_link);

        article.appendChild(preview);
        view.appendChild(article);
    }
}

function populateNav(search, page, pages)
{
    const PAGES_PER_SIDE = 4;

    // Put the serach into a url param so we can use
    // it in links
    let page_params = new URLSearchParams();
    page_params.set("s", search);
    page_params.set("p", 1);

    let page_nav = document.getElementById("nav_pages");

    // Add the first link
    page_nav.appendChild(generate_nav_item("First", "/search?" + page_params, false, page == 1));

    // Determine the range, start and end pages.
    let rmin = Math.max(1, page-PAGES_PER_SIDE);
    let rmax = Math.min(page+PAGES_PER_SIDE, pages);
    let lshort = PAGES_PER_SIDE-(page-rmin);
    let rshort = PAGES_PER_SIDE-(rmax-page);
    rmin -= rshort;
    rmin = Math.max(1, rmin);
    rmax += lshort;
    rmax = Math.min(rmax, pages);

    for (let i = rmin; i <= rmax; i++) {
        page_params.set("p", i);
        page_nav.appendChild(generate_nav_item(i, "/search?" + page_params, i == page, false));
    }

    page_params.set("p", pages);
    page_nav.appendChild(generate_nav_item("Last", "/search?" + page_params, false, page == pages));
}