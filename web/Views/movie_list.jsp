<%-- 
    Document   : movie_list
    Created on : Oct 22, 2025, 5:26:37 PM
    Author     : dinhh
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Movies | Filter</title>
        <link rel="stylesheet" href="css/movie_list.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Layout.css">
        <script src="js/movie_list.js"></script>
    </head>
    <body>
        <jsp:include page="/Inculude/Header.jsp" />
        <div class="movie-list-container">
            <h2 class="page-title">MOVIES</h2>

            <div class="filter-bar">
                <a href="${pageContext.request.contextPath}/movies?status=now showing"
                   class="${statusFilter == 'now showing' ? 'active' : ''}">Now Showing</a>
                <a href="${pageContext.request.contextPath}/movies?status=coming soon"
                   class="${statusFilter == 'coming soon' ? 'active' : ''}">Upcoming</a>
            </div>

            <div class="movie-grid">
                <c:forEach var="movie" items="${movies}">
                    <div class="movie-card" onclick="openModal(${movie.movieId})">
                        <div class="poster">
                            <img src="${movie.posterUrl}" alt="${movie.title}">
                        </div>
                        <div class="movie-info">
                            <h3>${movie.title}</h3>
                            <p><strong>${movie.directorName}</strong></p>
                            <p>${movie.durationMinutes} min</p>
                        </div>
                    </div>

                    <!-- 💬 Movie Detail Modal -->
                    <div id="movieModal-${movie.movieId}" class="modal">
                        <div class="modal-content">
                            <span class="close" onclick="closeModal(${movie.movieId})">&times;</span>

                            <!-- Title -->
                            <h2 class="movie-title">${movie.title}</h2>

                            <div class="modal-body-layout">
                                <!-- Left: Poster + Book -->
                                <div class="left-section">
                                    <img src="${movie.posterUrl}" alt="${movie.title}" class="poster-img">
                                    <form action="${pageContext.request.contextPath}/selectionShowtime" method="get">
                                        <input type="hidden" name="movieId" value="${movie.movieId}">
                                        <button type="submit" class="book-btn">Book Ticket</button>
                                    </form>
                                </div>

                                <!-- Right: Info + Trailer -->
                                <div class="right-section">
                                    <table class="movie-info-table">
                                        <tr><th>Director:</th><td>${movie.directorName}</td></tr>
                                        <tr><th>Language:</th><td>${movie.language}</td></tr>
                                        <tr><th>Duration:</th><td>${movie.durationMinutes} min</td></tr>
                                        <tr><th>Release:</th><td>${movie.releaseDate}</td></tr>
                                        <tr><th>Rating:</th><td>${movie.rating}</td></tr>
                                        <tr>
                                            <th>Genres:</th>
                                            <td>
                                                <c:forEach var="g" items="${movie.genres}" varStatus="loop">
                                                    ${g}<c:if test="${!loop.last}">, </c:if>
                                                </c:forEach>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Actors:</th>
                                            <td>
                                                <c:forEach var="a" items="${movie.actors}" varStatus="loop">
                                                    ${a}<c:if test="${!loop.last}">, </c:if>
                                                </c:forEach>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Description:</th>
                                            <td class="desc-cell">${movie.description}</td>
                                        </tr>
                                    </table>

                                    <c:if test="${not empty movie.trailerUrl}">
                                        <c:set var="embedUrl" value="${fn:replace(movie.trailerUrl, 'watch?v=', 'embed/')}" />
                                        <h3 class="trailer-title">Trailer</h3>
                                        <div class="trailer-container">
                                            <iframe width="400" height="225"
                                                    src="${embedUrl}"
                                                    title="YouTube trailer"
                                                    frameborder="0"
                                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                                    allowfullscreen>
                                            </iframe>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <jsp:include page="/Inculude/Footer.jsp" />
    </body>
</html>