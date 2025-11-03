package Models;

import java.sql.Timestamp;

public class Review {

    // ======== CÁC TRƯỜNG CHÍNH (TỪ BẢNG REVIEW) ========
    private int reviewId;
    private int userId;
    private int movieId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    // ======== TRƯỜNG MỞ RỘNG (JOIN TỪ USERS) ========
    private String userName; // tên người viết review

    // ======== CONSTRUCTOR ========

    public Review() {
    }

    public Review(int reviewId, int userId, int movieId, int rating, String comment, Timestamp createdAt) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.movieId = movieId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    // ======== GETTER & SETTER ========

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    // ======== TO STRING ========

    @Override
    public String toString() {
        return "Review{" +
                "reviewId=" + reviewId +
                ", userId=" + userId +
                ", movieId=" + movieId +
                ", rating=" + rating +
                ", userName='" + userName + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
