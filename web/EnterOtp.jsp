<!doctype html>
<html lang="vi">
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Enter OTP - Hola Cinema</title>
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

        /* OTP container v?i glassmorphism nâng c?p */
        .otp-container {
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
        .otp-header {
            text-align: center;
            margin-bottom: 40px;
            animation: fadeIn 0.3s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .otp-header .icon {
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

        .otp-header .icon i {
            font-size: 45px;
            color: white;
        }

        .otp-header h1 {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }

        .otp-header p {
            color: #b3b3b3;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        /* Info box */
        .info-box {
            background: rgba(229, 9, 20, 0.08);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 35px;
            border: 1px solid rgba(229, 9, 20, 0.2);
            text-align: center;
        }

        .info-box i {
            font-size: 32px;
            color: #e50914;
            margin-bottom: 15px;
            display: block;
        }

        .info-box p {
            color: #e0e0e0;
            font-size: 15px;
            line-height: 1.6;
            margin: 0;
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
            font-size: 18px;
            font-weight: 600;
            letter-spacing: 8px;
            text-align: center;
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
            letter-spacing: normal;
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

        /* Alert styling */
        .alert {
            border-radius: 12px;
            border: none;
            background: rgba(220, 53, 69, 0.15);
            border-left: 4px solid #dc3545;
            color: #fff;
            animation: shake 0.5s ease;
            margin-bottom: 20px;
            padding: 15px 20px;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        /* Responsive */
        @media (max-width: 576px) {
            .otp-container {
                padding: 40px 30px;
                border-radius: 24px;
            }

            .otp-header h1 {
                font-size: 1.8rem;
            }

            .button-group {
                flex-direction: column;
            }

            .info-box {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Cinema Background -->
    <div class="cinema-background"></div>

    <!-- OTP Container -->
    <div class="otp-container">
        <div class="otp-header">
            <div class="icon">
                <i class="fas fa-shield-alt"></i>
            </div>
            <h1>Enter OTP Code</h1>
            <p>We've sent a verification code to your email</p>
        </div>

        <div class="info-box">
            <i class="fas fa-envelope-open-text"></i>
            <p>Please check your email inbox (and spam folder) for the 6-digit OTP code we just sent you.</p>
        </div>

        <% if (request.getAttribute("message") != null) { %>
        <div class="alert" role="alert">
            <i class="fas fa-exclamation-circle"></i>
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <form action="ValidateOtp" method="POST">
            <div class="input-group-custom">
                <label for="otp">OTP Code</label>
                <input type="text" id="otp" name="otp" class="form-control"
                       placeholder="000000" maxlength="6" required pattern="[0-9]{6}">
                <i class="fas fa-key"></i>
                <div class="form-hint">
                    <i class="fas fa-info-circle"></i>
                    <span>Enter the 6-digit code from your email</span>
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check-circle"></i>
                    Verify OTP
                </button>
                <button type="button" class="btn btn-secondary" onclick="window.location.href='forgotPassword'">
                    <i class="fas fa-arrow-left"></i>
                    Back
                </button>
            </div>
        </form>
    </div>
</body>
</html>

