<!doctype html>
<html lang="vi">
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Quên M?t Kh?u - Hola Cinema</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            background: #000;
            padding: 20px;
        }

        /* Background v?i cinema theme */
        .cinema-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                url('https://images.unsplash.com/photo-1542204165-65bf26472b9b?q=80&w=1974&auto=format&fit=crop') center/cover;
            animation: bgZoom 20s ease-in-out infinite alternate;
        }

        @keyframes bgZoom {
            0% { transform: scale(1); }
            100% { transform: scale(1.06); }
        }

        /* Floating particles effect */
        .cinema-background::before {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 50%, rgba(229, 9, 20, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(229, 9, 20, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 40% 80%, rgba(229, 9, 20, 0.12) 0%, transparent 50%);
            animation: float 15s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0); opacity: 0.5; }
            33% { transform: translate(30px, -30px); opacity: 0.8; }
            66% { transform: translate(-20px, 20px); opacity: 0.6; }
        }

        /* Forgot container v?i glassmorphism nâng c?p */
        .forgot-container {
            max-width: 580px;
            width: 100%;
            padding: 50px 50px;
            margin: 20px;
            /* Glassmorphism premium */
            background: rgba(0, 0, 0, 0.45);
            backdrop-filter: blur(20px);
            border-radius: 28px;
            box-shadow: 0 8px 40px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #fff;
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Logo v?i animation */
        .forgot-header {
            text-align: center;
            margin-bottom: 40px;
            animation: fadeIn 0.3s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .forgot-header .icon {
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, #ff2b2b, #d40000);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            box-shadow: 0 10px 30px rgba(229, 9, 20, 0.4);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); box-shadow: 0 10px 30px rgba(229, 9, 20, 0.4); }
            50% { transform: scale(1.05); box-shadow: 0 15px 40px rgba(229, 9, 20, 0.6); }
        }

        .forgot-header .icon i {
            font-size: 45px;
            color: white;
        }

        .forgot-header h1 {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }

        .forgot-header p {
            color: #b3b3b3;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        /* Steps container */
        .steps-container {
            background: rgba(229, 9, 20, 0.08);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 35px;
            border: 1px solid rgba(229, 9, 20, 0.2);
        }

        .step-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 20px;
        }

        .step-item:last-child {
            margin-bottom: 0;
        }

        .step-number {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, #ff2b2b, #d40000);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 800;
            font-size: 17px;
            flex-shrink: 0;
            box-shadow: 0 4px 15px rgba(229, 9, 20, 0.3);
        }

        .step-content {
            flex: 1;
            padding-top: 10px;
        }

        .step-content p {
            color: #e0e0e0;
            font-size: 15px;
            line-height: 1.6;
            font-weight: 500;
        }

        /* Form inputs nâng c?p */
        .input-group-custom {
            position: relative;
            margin-bottom: 25px;
        }

        .input-group-custom label {
            display: block;
            margin-bottom: 12px;
            color: #b3b3b3;
            font-weight: 600;
            font-size: 15px;
        }

        .input-group-custom .fa-solid {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 18px;
            transition: color 0.3s ease;
            z-index: 2;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #fff;
            height: 56px;
            padding-left: 52px;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            width: 100%;
        }

        .form-control:focus {
            background: rgba(0, 0, 0, 0.6);
            border-color: #e50914;
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.15);
            color: #fff;
            outline: none;
        }

        .form-control:focus + .fa-solid {
            color: #e50914;
        }

        .form-control::placeholder {
            color: #888;
        }

        .form-hint {
            margin-top: 10px;
            color: #888;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-hint i {
            color: #e50914;
        }

        /* Button group */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 16px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-primary {
            background: linear-gradient(90deg, #ff2b2b, #d40000);
            color: white;
            box-shadow: 0 4px 15px rgba(229, 9, 20, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(229, 9, 20, 0.5);
            background: linear-gradient(90deg, #ff3838, #e50914);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        /* Responsive */
        @media (max-width: 576px) {
            .forgot-container {
                padding: 40px 30px;
                border-radius: 24px;
            }

            .forgot-header h1 {
                font-size: 1.8rem;
            }

            .button-group {
                flex-direction: column;
            }

            .steps-container {
                padding: 25px 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Cinema Background -->
    <div class="cinema-background"></div>

    <!-- Forgot Container -->
    <div class="forgot-container">
        <div class="forgot-header">
            <div class="icon">
                <i class="fas fa-key"></i>
            </div>
            <h1>Forgot Password?</h1>
            <p>Don't worry! We'll help you recover your account</p>
        </div>

        <div class="steps-container">
            <div class="step-item">
                <div class="step-number">1</div>
                <div class="step-content">
                    <p>Enter your registered email address</p>
                </div>
            </div>
            <div class="step-item">
                <div class="step-number">2</div>
                <div class="step-content">
                    <p>We'll send you an OTP verification code</p>
                </div>
            </div>
            <div class="step-item">
                <div class="step-number">3</div>
                <div class="step-content">
                    <p>Enter the OTP to reset your password</p>
                </div>
            </div>
        </div>

        <form action="forgotPassword" method="POST">
            <div class="input-group-custom">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="example@email.com"
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                <i class="fas fa-envelope"></i>
                <div class="form-hint">
                    <i class="fas fa-info-circle"></i>
                    <span>Enter the email you used to register your account</span>
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i>
                    Send OTP
                </button>
                <button type="button" class="btn btn-secondary" onclick="window.location.href='login'">
                    <i class="fas fa-arrow-left"></i>
                    Back
                </button>
            </div>
        </form>
    </div>
</body>
</html>

