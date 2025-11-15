<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hola Cinema - Trải Nghiệm Điện Ảnh Đỉnh Cao</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css">
        <style>
            :root {
                --primary: #6C5CE7;
                --primary-dark: #5B4BC4;
                --secondary: #A66EFF;
                --bg-light: #F5F6FA;
                --text-dark: #2D3436;
                --text-light: #636E72;
                --shadow: 0 4px 12px rgba(0,0,0,0.06);
                --shadow-hover: 0 8px 24px rgba(0,0,0,0.12);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background: linear-gradient(145deg, #f8f8ff 0%, #eef2ff 50%, #fafafa 100%);
                color: var(--text-dark);
                overflow-x: hidden;
                line-height: 1.6;
                position: relative;
            }

            /* Blur Blobs Background */
            body::before,
            body::after {
                content: '';
                position: fixed;
                border-radius: 50%;
                filter: blur(120px);
                opacity: 0.15;
                z-index: 0;
                pointer-events: none;
            }

            body::before {
                width: 600px;
                height: 600px;
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                top: -200px;
                left: -200px;
            }

            body::after {
                width: 500px;
                height: 500px;
                background: linear-gradient(135deg, #60A5FA, #A78BFA);
                bottom: -150px;
                right: -150px;
            }

            /* HEADER - Glassmorphism khi scroll */
            header {
                background: #fff;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                padding: 18px 80px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                position: sticky;
                top: 0;
                z-index: 1000;
                transition: all 0.3s ease;
                box-shadow: var(--shadow);
            }

            header.scrolled {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(20px);
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            }

            .logo {
                font-size: 28px;
                font-weight: 900;
                background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                display: flex;
                align-items: center;
                gap: 10px;
                letter-spacing: -0.5px;
            }

            .logo i {
                background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                font-size: 32px;
            }

            nav ul {
                list-style: none;
                display: flex;
                gap: 35px;
                margin: 0;
                padding: 0;
            }

            nav ul li a {
                text-decoration: none;
                color: var(--text-dark);
                font-weight: 600;
                font-size: 15px;
                transition: all 0.3s ease;
                position: relative;
                padding: 8px 0;
            }

            nav ul li a::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 0;
                height: 3px;
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                border-radius: 10px;
                transition: width 0.3s ease;
            }

            nav ul li a:hover::after,
            nav ul li a.active::after {
                width: 100%;
            }

            nav ul li a:hover,
            nav ul li a.active {
                color: var(--primary);
            }

            .nav-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .btn {
                background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
                color: #fff;
                border: none;
                padding: 12px 28px;
                border-radius: 12px;
                cursor: pointer;
                text-decoration: none;
                font-weight: 700;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 4px 15px rgba(108, 92, 231, 0.3);
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(108, 92, 231, 0.4);
            }

            /* HERO BANNER - Gradient overlay + Text + CTA */
            .hero-banner {
                width: 100%;
                height: 480px;
                background:
                    linear-gradient(180deg, rgba(0,0,0,0.4) 0%, rgba(0,0,0,0.1) 60%, rgba(0,0,0,0.3) 100%),
                    linear-gradient(135deg, rgba(108, 92, 231, 0.7), rgba(166, 110, 255, 0.6)),
                    url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1920&q=80') center/cover no-repeat;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                position: relative;
                overflow: hidden;
                padding: 60px 20px;
            }

            .hero-content {
                text-align: center;
                max-width: 800px;
                z-index: 2;
                animation: fadeInUp 0.8s ease-out;
            }

            @keyframes fadeInUp {
                from { opacity: 0; transform: translateY(40px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .hero-content h1 {
                font-size: 56px;
                font-weight: 900;
                margin-bottom: 20px;
                line-height: 1.2;
                text-shadow: 0 4px 20px rgba(0,0,0,0.3);
            }

            .hero-content p {
                font-size: 20px;
                margin-bottom: 35px;
                opacity: 0.95;
                font-weight: 500;
            }

            .hero-buttons {
                display: flex;
                gap: 20px;
                justify-content: center;
                flex-wrap: wrap;
            }

            .btn-hero {
                padding: 16px 40px;
                font-size: 16px;
                border-radius: 12px;
                font-weight: 700;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                transition: all 0.3s ease;
            }

            .btn-hero-primary {
                background: #fff;
                color: var(--primary);
                box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            }

            .btn-hero-primary:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(0,0,0,0.3);
            }

            .btn-hero-secondary {
                background: rgba(255,255,255,0.15);
                color: #fff;
                border: 2px solid rgba(255,255,255,0.5);
                backdrop-filter: blur(10px);
            }

            .btn-hero-secondary:hover {
                background: rgba(255,255,255,0.25);
                transform: translateY(-3px);
            }

            /* NOW SHOWING SECTION */
            .section {
                padding: 70px 20px;
                background: transparent;
                position: relative;
                z-index: 1;
            }

            .section-container {
                max-width: 1200px;
                margin: 0 auto;
            }

            .section-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 40px;
                flex-wrap: wrap;
                gap: 20px;
            }

            .section-header-left {
                flex: 1;
            }

            .section-title {
                font-size: 38px;
                font-weight: 800;
                color: var(--text-dark);
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .section-title i {
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                font-size: 36px;
            }

            .section-subtitle {
                font-size: 16px;
                color: var(--text-light);
                font-weight: 500;
                font-style: italic;
            }

            .view-all-btn {
                padding: 12px 28px;
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                color: #fff;
                text-decoration: none;
                border-radius: 10px;
                font-weight: 600;
                font-size: 14px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(108, 92, 231, 0.3);
            }

            .view-all-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(108, 92, 231, 0.4);
            }

            /* Horizontal Divider */
            .section-divider {
                height: 3px;
                background: linear-gradient(90deg, transparent, var(--primary), var(--secondary), transparent);
                margin: 60px auto;
                max-width: 600px;
                border-radius: 10px;
                opacity: 0.3;
            }

            /* MOVIE GRID */
            .movie-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 30px;
                animation: fadeIn 0.6s ease-out;
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            .movie-card {
                background: #fff;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                cursor: pointer;
                position: relative;
            }

            .movie-card:hover {
                transform: translateY(-10px) scale(1.02);
                box-shadow: 0 12px 30px rgba(108, 92, 231, 0.2);
            }

            .movie-poster {
                width: 100%;
                height: 360px;
                object-fit: cover;
                position: relative;
                transition: transform 0.4s ease;
            }

            .movie-card:hover .movie-poster {
                transform: scale(1.05);
            }

            .movie-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                color: #fff;
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            }

            .movie-info {
                padding: 20px;
            }

            .movie-title {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 10px;
                color: var(--text-dark);
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .movie-meta {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 15px;
                font-size: 14px;
                color: var(--text-light);
            }

            .movie-meta span {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .movie-rating {
                display: flex;
                align-items: center;
                gap: 5px;
                color: #FFA500;
                font-weight: 600;
            }

            .btn-book {
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                color: #fff;
                border: none;
                border-radius: 10px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-book:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(108, 92, 231, 0.5);
                background: linear-gradient(135deg, var(--primary-dark), var(--primary));
            }

            /* COMING SOON SECTION */
            .coming-soon-carousel {
                display: flex;
                gap: 25px;
                overflow-x: auto;
                scroll-behavior: smooth;
                padding: 10px 0 20px 0;
                scrollbar-width: thin;
                scrollbar-color: var(--primary) #e0e0e0;
            }

            .coming-soon-carousel::-webkit-scrollbar {
                height: 8px;
            }

            .coming-soon-carousel::-webkit-scrollbar-track {
                background: #e0e0e0;
                border-radius: 10px;
            }

            .coming-soon-carousel::-webkit-scrollbar-thumb {
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                border-radius: 10px;
            }

            .coming-soon-card {
                min-width: 280px;
                background: #fff;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 6px 18px rgba(0,0,0,0.1);
                transition: all 0.4s ease;
                cursor: pointer;
                position: relative;
            }

            .coming-soon-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 12px 30px rgba(166, 110, 255, 0.25);
            }

            .coming-soon-badge {
                position: absolute;
                top: 15px;
                left: 15px;
                background: linear-gradient(135deg, #FF6B6B, #FF8E53);
                color: #fff;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                box-shadow: 0 4px 15px rgba(255, 107, 107, 0.4);
                z-index: 10;
            }

            /* FOOTER */
            footer {
                background: #1E1E1E;
                color: #ddd;
                padding: 60px 20px 30px 20px;
                position: relative;
                z-index: 1;
            }

            .footer-container {
                max-width: 1200px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 40px;
                margin-bottom: 40px;
            }

            .footer-section h3 {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 20px;
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .footer-section p,
            .footer-section ul {
                font-size: 14px;
                line-height: 1.8;
                color: #bbb;
            }

            .footer-section ul {
                list-style: none;
                padding: 0;
            }

            .footer-section ul li {
                margin-bottom: 12px;
            }

            .footer-section ul li a {
                color: #bbb;
                text-decoration: none;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .footer-section ul li a:hover {
                color: var(--secondary);
                transform: translateX(5px);
            }

            .social-icons {
                display: flex;
                gap: 15px;
                margin-top: 15px;
            }

            .social-icons a {
                width: 40px;
                height: 40px;
                background: rgba(255,255,255,0.1);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #ddd;
                font-size: 18px;
                transition: all 0.3s ease;
            }

            .social-icons a:hover {
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                color: #fff;
                transform: translateY(-3px);
            }

            .footer-bottom {
                text-align: center;
                padding-top: 30px;
                border-top: 1px solid rgba(255,255,255,0.1);
                color: #888;
                font-size: 14px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                header {
                    padding: 15px 20px;
                }

                nav ul {
                    gap: 15px;
                    font-size: 14px;
                }

                .hero-banner {
                    height: 400px;
                }

                .hero-content h1 {
                    font-size: 32px;
                }

                .hero-content p {
                    font-size: 16px;
                }

                .section {
                    padding: 50px 15px;
                }

                .section-header {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .section-title {
                    font-size: 28px;
                }

                .movie-grid {
                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                    gap: 20px;
                }

                .footer-container {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                body::before,
                body::after {
                    display: none;
                }
            }
        </style>
    </head>
    <body>
        <!-- HEADER -->
        <header id="header">
            <div class="logo">
                <i class="ri-movie-2-fill"></i>
                Hola Cinema
            </div>
            <nav>
                <ul>
                    <li><a href="#" class="active">Home</a></li>
                    <li><a href="#now-showing">Now Showing</a></li>
                    <li><a href="#about">About</a></li>
                    <li><a href="#contact">Contact</a></li>
                </ul>
            </nav>
            <div class="nav-right">
                <a href="${pageContext.request.contextPath}/login" class="btn">
                    <i class="ri-login-box-line"></i>
                    Login
                </a>
            </div>
        </header>

        <!-- HERO BANNER -->
        <section class="hero-banner">
            <div class="hero-content">
                <h1>Experience Cinema Like Never Before</h1>
                <p>Immerse yourself in the magic of movies with premium sound, stunning visuals, and ultimate comfort</p>
                <div class="hero-buttons">
                    <a href="#now-showing" class="btn-hero btn-hero-primary">
                        <i class="ri-ticket-2-line"></i>
                        Book Tickets Now
                    </a>
                    <a href="#" class="btn-hero btn-hero-secondary">
                        <i class="ri-play-circle-line"></i>
                        Watch Trailer
                    </a>
                </div>
            </div>
        </section>

        <!-- NOW SHOWING SECTION -->
        <section class="section" id="now-showing">
            <div class="section-container">
                <div class="section-header">
                    <div class="section-header-left">
                        <h2 class="section-title">
                            <i class="ri-film-line"></i>
                            Now Showing
                        </h2>
                        <p class="section-subtitle">Discover the latest blockbusters and exclusive premieres at Hola Cinema</p>
                    </div>
                    <a href="#" class="view-all-btn">
                        View All
                        <i class="ri-arrow-right-line"></i>
                    </a>
                </div>

                <div class="movie-grid">
                    <c:forEach var="movie" items="${listMovie}">
                        <div class="movie-card" onclick="window.location.href='${pageContext.request.contextPath}/moviedetail?movieId=${movie.movieID}'">
                            <div style="position: relative; overflow: hidden;">
                                <img src="${pageContext.request.contextPath}/uploads/${movie.posterURL}"
                                     alt="${movie.title}" class="movie-poster">
                                <div class="movie-badge">
                                    <i class="ri-star-fill"></i> ${movie.rating}/10
                                </div>
                            </div>
                            <div class="movie-info">
                                <h3 class="movie-title">${movie.title}</h3>
                                <div class="movie-meta">
                                    <span>
                                        <i class="ri-time-line"></i>
                                        ${movie.duration} min
                                    </span>
                                    <span>
                                        <i class="ri-calendar-line"></i>
                                        ${movie.releaseDate}
                                    </span>
                                </div>
                                <button class="btn-book">
                                    <i class="ri-ticket-2-line"></i>
                                    Book Now
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- SECTION DIVIDER -->
        <div class="section-divider"></div>

        <!-- COMING SOON SECTION -->
        <section class="section" id="coming-soon">
            <div class="section-container">
                <div class="section-header">
                    <div class="section-header-left">
                        <h2 class="section-title">
                            <i class="ri-calendar-event-line"></i>
                            Coming Soon
                        </h2>
                        <p class="section-subtitle">Upcoming movies that will blow your mind in the near future</p>
                    </div>
                    <a href="#" class="view-all-btn">
                        View All
                        <i class="ri-arrow-right-line"></i>
                    </a>
                </div>

                <div class="coming-soon-carousel">
                    <!-- Example Coming Soon Cards -->
                    <div class="coming-soon-card">
                        <div style="position: relative;">
                            <div class="coming-soon-badge">COMING SOON</div>
                            <img src="https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=400&q=80"
                                 alt="Coming Soon Movie" class="movie-poster" style="height: 380px;">
                        </div>
                        <div class="movie-info">
                            <h3 class="movie-title">Avatar 3: The Seed Bearer</h3>
                            <div class="movie-meta">
                                <span>
                                    <i class="ri-calendar-line"></i>
                                    Dec 2025
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="coming-soon-card">
                        <div style="position: relative;">
                            <div class="coming-soon-badge">COMING SOON</div>
                            <img src="https://images.unsplash.com/photo-1594908900066-3f47337549d8?w=400&q=80"
                                 alt="Coming Soon Movie" class="movie-poster" style="height: 380px;">
                        </div>
                        <div class="movie-info">
                            <h3 class="movie-title">The Dark Knight Returns</h3>
                            <div class="movie-meta">
                                <span>
                                    <i class="ri-calendar-line"></i>
                                    Jan 2026
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="coming-soon-card">
                        <div style="position: relative;">
                            <div class="coming-soon-badge">COMING SOON</div>
                            <img src="https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=400&q=80"
                                 alt="Coming Soon Movie" class="movie-poster" style="height: 380px;">
                        </div>
                        <div class="movie-info">
                            <h3 class="movie-title">Interstellar 2: Beyond Time</h3>
                            <div class="movie-meta">
                                <span>
                                    <i class="ri-calendar-line"></i>
                                    Mar 2026
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="coming-soon-card">
                        <div style="position: relative;">
                            <div class="coming-soon-badge">COMING SOON</div>
                            <img src="https://images.unsplash.com/photo-1485846234645-a62644f84728?w=400&q=80"
                                 alt="Coming Soon Movie" class="movie-poster" style="height: 380px;">
                        </div>
                        <div class="movie-info">
                            <h3 class="movie-title">Inception: Dream Within</h3>
                            <div class="movie-meta">
                                <span>
                                    <i class="ri-calendar-line"></i>
                                    May 2026
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FOOTER -->
        <footer>
            <div class="footer-container">
                <!-- Contact Info -->
                <div class="footer-section">
                    <h3><i class="ri-map-pin-line"></i> Contact Info</h3>
                    <p><i class="ri-phone-line"></i> <strong>Hotline:</strong> 1900-xxxx</p>
                    <p><i class="ri-mail-line"></i> <strong>Email:</strong> support@holacinema.com</p>
                    <p><i class="ri-building-line"></i> <strong>Address:</strong> 123 Cinema Street, District 1, Ho Chi Minh City</p>
                </div>

                <!-- Quick Links -->
                <div class="footer-section">
                    <h3><i class="ri-links-line"></i> Quick Links</h3>
                    <ul>
                        <li><a href="#now-showing"><i class="ri-film-line"></i> Movies</a></li>
                        <li><a href="#"><i class="ri-price-tag-3-line"></i> Promotions</a></li>
                        <li><a href="#"><i class="ri-ticket-2-line"></i> Booking</a></li>
                        <li><a href="#"><i class="ri-information-line"></i> About Us</a></li>
                    </ul>
                </div>

                <!-- Social Media -->
                <div class="footer-section">
                    <h3><i class="ri-share-line"></i> Follow Us</h3>
                    <p>Stay connected with us on social media</p>
                    <div class="social-icons">
                        <a href="#" title="Facebook"><i class="ri-facebook-fill"></i></a>
                        <a href="#" title="Instagram"><i class="ri-instagram-line"></i></a>
                        <a href="#" title="Youtube"><i class="ri-youtube-fill"></i></a>
                        <a href="#" title="Twitter"><i class="ri-twitter-x-line"></i></a>
                    </div>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2025 Hola Cinema. All rights reserved. Designed with <i class="ri-heart-fill" style="color: #FF6B6B;"></i> by Team Dev</p>
            </div>
        </footer>

        <script>
            // Header scroll effect
            window.addEventListener('scroll', function() {
                const header = document.getElementById('header');
                if (window.scrollY > 50) {
                    header.classList.add('scrolled');
                } else {
                    header.classList.remove('scrolled');
                }
            });
        </script>
    </body>
</html>

