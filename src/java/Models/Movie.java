package Models;


import java.time.LocalDate;
import java.util.List;
import java.sql.Date;
/**
 *
 * @author dinhh
 */
public class Movie {

    private int movieId;
    private String title;
    private String rating;
    private int durationMinutes;
    private String language;
    private LocalDate releaseDate;
    private String status;
    private String posterUrl;
    private String trailerUrl;
    private String directorName;
    private String description;
    private List<Integer> genreIds;
    private List<Integer> actorIds;
    private List<String> genres;
    private List<String> actors;


    // ======== CONSTRUCTOR ========
    public Movie() {
    }

    public Movie(int movieId, String title, String rating, int durationMinutes, String language, LocalDate releaseDate,
            String status, String posterUrl, String trailerUrl, String directorName, String description,
            List<Integer> genreIds, List<Integer> actorIds) {
        this.movieId = movieId;
        this.title = title;
        this.rating = rating;
        this.durationMinutes = durationMinutes;
        this.language = language;
        this.releaseDate = releaseDate;
        this.status = status;
        this.posterUrl = posterUrl;
        this.trailerUrl = trailerUrl;
        this.directorName = directorName;
        this.description = description;
        this.genreIds = genreIds;
        this.actorIds = actorIds;
    }
    // ======== GETTER & SETTER ========

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;

    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public LocalDate getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(LocalDate releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;

    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }

    public String getTrailerUrl() {
        return trailerUrl;
    }

    public void setTrailerUrl(String trailerUrl) {
        this.trailerUrl = trailerUrl;
    }

    public String getDirectorName() {
        return directorName;
    }

    public void setDirectorName(String directorName) {
        this.directorName = directorName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Integer> getGenreIds() {
        return genreIds;
    }

    public void setGenreIds(List<Integer> genreIds) {
        this.genreIds = genreIds;
    }

    public List<Integer> getActorIds() {
        return actorIds;
    }

    public void setActorIds(List<Integer> actorIds) {
        this.actorIds = actorIds;
    }

    public List<String> getGenres() {
        return genres;
    }

    public void setGenres(List<String> genres) {
        this.genres = genres;
    }

    public List<String> getActors() {
        return actors;
    }

    public void setActors(List<String> actors) {
        this.actors = actors;
    }



    // ======== PHƯƠNG THỨC HỖ TRỢ (tùy chọn) ========

    @Override
    public String toString() {
        return "Movie{" +
                "movieId=" + movieId +
                ", title='" + title + '\'' +
                ", rating='" + rating + '\'' +
                ", releaseDate=" + releaseDate +
                ", status='" + status + '\'' +
                '}';
    }

}
