package Models;

import java.sql.Date;
import java.util.List;

public class Movie {

    // ======== CÁC THUỘC TÍNH CHÍNH (từ bảng Movie) ========
    private int movieId;
    private String title;
    private String description;
    private int durationMinutes;
    private String language;
    private Date releaseDate;
    private String rating;
    private String posterUrl;
    private String status;
    private int directorId;

    // ======== THÔNG TIN ĐẠO DIỄN (join từ bảng Director) ========
    private String directorName;
    private String directorBio;
    private String directorPhoto;

    // ======== CÁC DANH SÁCH LIÊN QUAN (được set trong DAO) ========
    private List<String> genres;    // Từ bảng Genre
    private List<Actor> actors;     // Danh sách diễn viên
    private List<Review> reviews;   // Danh sách đánh giá

    // ======== CONSTRUCTOR ========
    public Movie() {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getDirectorId() {
        return directorId;
    }

    public void setDirectorId(int directorId) {
        this.directorId = directorId;
    }

    public String getDirectorName() {
        return directorName;
    }

    public void setDirectorName(String directorName) {
        this.directorName = directorName;
    }

    public String getDirectorBio() {
        return directorBio;
    }

    public void setDirectorBio(String directorBio) {
        this.directorBio = directorBio;
    }

    public String getDirectorPhoto() {
        return directorPhoto;
    }

    public void setDirectorPhoto(String directorPhoto) {
        this.directorPhoto = directorPhoto;
    }

    public List<String> getGenres() {
        return genres;
    }

    public void setGenres(List<String> genres) {
        this.genres = genres;
    }

    public List<Actor> getActors() {
        return actors;
    }

    public void setActors(List<Actor> actors) {
        this.actors = actors;
    }

    public List<Review> getReviews() {
        return reviews;
    }

    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
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
