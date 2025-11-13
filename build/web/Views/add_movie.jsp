<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Movie</title>
        <meta charset="UTF-8">

        <!-- Select2 -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>


        <link href="css/add_movie.css" rel="stylesheet" >
        <link href="css/Layout.css" rel="stylesheet" >
        <script src="js/add_movie.js"></script>
    </head>
    <body>
        <jsp:include page="/Inculude/Header.jsp" />
        <div class="container">
            <h2>Add Movie</h2>
            <div class="form-wrapper">

                <!-- Right: Form -->
                <form class="movie-form" action="${pageContext.request.contextPath}/add_movie" method="post">

                    <input type="hidden" name="posterUrl" id="posterUrl">
                    <div class="poster-section" onclick="openPosterModal()">
                        <div id="posterFrame" class="poster-frame">
                            <span id="posterIcon">+</span>
                            <p id="posterText">Add poster</p>
                            <img id="posterPreview" src="" alt="Poster preview" style="display:none;">
                        </div>
                    </div>

                    <!-- Poster Modal -->
                    <div id="posterModal" class="popup-modal">
                        <div class="popup-modal-content">
                            <span class="close" onclick="closePosterModal()">&times;</span>
                            <h3>Add Poster URL</h3>
                            <input type="text" id="posterUrlInput" placeholder="Enter poster URL">
                            <button type="button" onclick="setPoster()">OK</button>
                        </div> 
                    </div>

                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" maxlength="300" required>
                    </div>

                    <div class="form-group">
                        <label>Rating</label>
                        <select name="rating">
                            <option value="G">G</option>
                            <option value="PG">PG</option>
                            <option value="PG-13">PG-13</option>
                            <option value="R">R</option>
                        </select>
                    </div>

                    <div class="form-row">
                        <div class="form-group half">
                            <label>Duration (min)</label>
                            <input type="number" name="duration" min="60" required>
                        </div>
                        <div class="form-group half">
                            <label>Language</label>
                            <select name="language">
                                <option value="English">English</option>
                                <option value="Vietnamese">Vietnamese</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group half">
                            <label>Release Date</label>
                            <input type="date" name="releaseDate" required>
                        </div>
                        <div class="form-group half">
                            <label>Status</label>
                            <select name="status" required>
                                <option value="coming soon">Coming Soon</option>
                                <option value="now showing">Now Showing</option>
                                <option value="archived">Archived</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Trailer URL</label>
                        <input type="text" name="trailerUrl" maxlength="300" required>
                    </div>

                    <div class="form-group">
                        <label>Director</label>
                        <input type="text" name="directorName" maxlength="300" required>
                    </div>

                    <div class="form-group">
                        <label>Genre</label>
                        <div class="inline-input">
                            <select id="genres" name="genres[]" multiple>
                                <c:forEach var="g" items="${genres}">
                                    <option value="${g[0]}">${g[1]}</option>
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
                                    <option value="${a[0]}">${a[1]}</option>
                                </c:forEach>
                            </select>
                            <button type="button" class="small-btn" onclick="openModal('actorModal')">Manage Actor</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" minlength="255" required></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit">Add movie</button>
                        <button type="button" class="cancel-btn" onclick="window.location.href = '${pageContext.request.contextPath}/movie_management'">
                            Cancel
                        </button>

                        <c:if test="${not empty errorMessage}">
                            <span class="error-message">${errorMessage}</span>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Genre -->
        <div id="genreModal" class="popup-modal">
            <div class="popup-modal-content">
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
        <div id="actorModal" class="popup-modal">
            <div class="popup-modal-content">
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
        <jsp:include page="/Inculude/Footer.jsp" />
    </body>
</html>



