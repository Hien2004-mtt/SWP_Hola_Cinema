<%-- 
    Document   : edit_movie
    Created on : Oct 22, 2025, 9:09:01 AM
    Author     : dinhh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Movie</title>
        <meta charset="UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <link href="css/add_movie.css" rel="stylesheet">
        <script src="js/add_movie.js"></script>
    </head>
    <body>
        <div class="container">
            <h2>Edit Movie</h2>
            <div class="form-wrapper">
                <form class="movie-form" action="${pageContext.request.contextPath}/edit_movie" method="post">
                    <input type="hidden" name="movieId" value="${movie.movieId}">
                    <input type="hidden" name="posterUrl" id="posterUrl" value="${movie.posterUrl}">

                    <div class="poster-section" onclick="openPosterModal()">
                        <div id="posterFrame" class="poster-frame">
                            <img id="posterPreview" src="${movie.posterUrl}" alt="Poster preview"
                                 style="${empty movie.posterUrl ? 'display:none;' : 'display:block;'}">
                            <c:if test="${empty movie.posterUrl}">
                                <span id="posterIcon">+</span>
                                <p id="posterText">Add poster</p>
                            </c:if>
                        </div>
                    </div>

                    <!-- Poster Modal -->
                    <div id="posterModal" class="modal">
                        <div class="modal-content">
                            <span class="close" onclick="closePosterModal()">&times;</span>
                            <h3>Edit Poster URL</h3>
                            <input type="text" id="posterUrlInput" placeholder="Enter poster URL" value="${movie.posterUrl}">
                            <button type="button" onclick="setPoster()">OK</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" value="${movie.title}" required>
                    </div>

                    <div class="form-group">
                        <label>Rating</label>
                        <select name="rating">
                            <option value="G" ${movie.rating == 'G' ? 'selected' : ''}>G</option>
                            <option value="PG" ${movie.rating == 'PG' ? 'selected' : ''}>PG</option>
                            <option value="PG-13" ${movie.rating == 'PG-13' ? 'selected' : ''}>PG-13</option>
                            <option value="R" ${movie.rating == 'R' ? 'selected' : ''}>R</option>
                        </select>
                    </div>

                    <div class="form-row">
                        <div class="form-group half">
                            <label>Duration (min)</label>
                            <input type="number" name="duration" min="60" value="${movie.durationMinutes}" required>
                        </div>
                        <div class="form-group half">
                            <label>Language</label>
                            <select name="language">
                                <option value="English" ${movie.language == 'English' ? 'selected' : ''}>English</option>
                                <option value="Vietnamese" ${movie.language == 'Vietnamese' ? 'selected' : ''}>Vietnamese</option>
                                <option value="Other" ${movie.language == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group half">
                            <label>Release Date</label>
                            <input type="date" name="releaseDate" value="${movie.releaseDate}" required>
                        </div>
                        <div class="form-group half">
                            <label>Status</label>
                            <select name="status">
                                <option value="coming soon" ${movie.status == 'coming soon' ? 'selected' : ''}>Coming Soon</option>
                                <option value="now showing" ${movie.status == 'now showing' ? 'selected' : ''}>Now Showing</option>
                                <option value="archived" ${movie.status == 'archived' ? 'selected' : ''}>Archived</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Trailer URL</label>
                        <input type="text" name="trailerUrl" value="${movie.trailerUrl}" required>
                    </div>

                    <div class="form-group">
                        <label>Director</label>
                        <input type="text" name="directorName" value="${movie.directorName}" required>
                    </div>

                    <div class="form-group">
                        <label>Genre</label>
                        <div class="inline-input">
                            <select id="genres" name="genres[]" multiple>
                                <c:forEach var="g" items="${genres}">
                                    <c:set var="isSelected" value="false" />
                                    <c:forEach var="gid" items="${movieGenreIds}">
                                        <c:if test="${gid == g[0]}">
                                            <c:set var="isSelected" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <option value="${g[0]}" ${isSelected ? 'selected' : ''}>${g[1]}</option>
                                </c:forEach>
                            </select>
                            <button type="button" class="small-btn" onclick="openModal('genreModal')">Manage Genre</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Actor</label>
                        <div class="inline-input">
                            <select id="actors" name="actors[]" multiple>
                                <c:forEach var="a" items="${actors}">
                                    <c:set var="isSelected" value="false" />
                                    <c:forEach var="aid" items="${movieActorIds}">
                                        <c:if test="${aid == a[0]}">
                                            <c:set var="isSelected" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <option value="${a[0]}" ${isSelected ? 'selected' : ''}>${a[1]}</option>
                                </c:forEach>
                            </select>
                            <button type="button" class="small-btn" onclick="openModal('actorModal')">Manage Actor</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" minlength="255" required>${movie.description}</textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit">Update Movie</button>
                        <button type="button" class="cancel-btn" onclick="window.location.href = '${pageContext.request.contextPath}/movie_management'">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Genre -->
        <div id="genreModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('genreModal')">&times;</span>
                <h3>Manage Genres</h3>

                <div class="manage-table-container">
                    <table class="manage-table">
                        <thead>
                            <tr>
                                <th>Genre Name</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="genreTableBody">
                            <c:forEach var="g" items="${genres}">
                                <tr>
                                    <td>${g[1]}</td>
                                    <td>
                                        <button type="button" class="delete-btn"
                                                onclick="removeItem(this, 'genres', ${g[0]})">×</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="add-section">
                    <input type="text" id="newGenre" placeholder="New genre name">
                    <button id="addGenreBtn" class="small-btn"
                            onclick="addNewOption('genres', 'newGenre')">Add</button>
                </div>
            </div>
        </div>

        <!-- Modal Actor -->
        <div id="actorModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('actorModal')">&times;</span>
                <h3>Manage Actors</h3>

                <div class="manage-table-container">
                    <table class="manage-table">
                        <thead>
                            <tr>
                                <th>Actor Name</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="actorList">
                            <c:forEach var="a" items="${actors}">
                                <tr>
                                    <td>${a[1]}</td>
                                    <td>
                                        <button type="button" class="delete-btn"
                                                onclick="removeItem(this, 'actors', ${a[0]})">×</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="add-section">
                    <input type="text" id="newActor" placeholder="New actor name">
                    <button id="addActorBtn" class="small-btn"
                            onclick="addNewOption('actors', 'newActor')">Add</button>
                </div>
            </div>
        </div>
    </body>
</html>
