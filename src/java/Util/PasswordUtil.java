package Util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and verification using BCrypt
 * BCrypt automatically handles salt generation and is resistant to rainbow table attacks
 * 
 * @author Hola Cinema Team
 */
public class PasswordUtil {
    
    // BCrypt work factor (log2 rounds) - 12 is a good balance between security and performance
    // Higher values = more secure but slower
    private static final int WORK_FACTOR = 12;

    /**
     * Validate password strength
     * Password must:
     * - Be at least 6 characters long
     * - Contain at least 1 uppercase letter
     * - Contain at least 1 special character
     *
     * @param password The password to validate
     * @return true if password meets all requirements, false otherwise
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }

        boolean hasUppercase = false;
        boolean hasSpecialChar = false;

        // Special characters: !@#$%^&*()_+-=[]{}|;:,.<>?
        String specialChars = "!@#$%^&*()_+-=[]{}|;:,.<>?";

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUppercase = true;
            }
            if (specialChars.indexOf(c) >= 0) {
                hasSpecialChar = true;
            }
        }

        return hasUppercase && hasSpecialChar;
    }

    /**
     * Get password validation error message
     * @param password The password to check
     * @return Error message describing what's missing, or null if valid
     */
    public static String getPasswordValidationError(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "Password cannot be empty!";
        }

        if (password.length() < 6) {
            return "Password must be at least 6 characters!";
        }

        boolean hasUppercase = false;
        boolean hasSpecialChar = false;
        String specialChars = "!@#$%^&*()_+-=[]{}|;:,.<>?";

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUppercase = true;
            }
            if (specialChars.indexOf(c) >= 0) {
                hasSpecialChar = true;
            }
        }

        if (!hasUppercase && !hasSpecialChar) {
            return "Password must contain at least 1 uppercase letter and 1 special character (!@#$%^&*()_+-=[]{}|;:,.<>?)";
        }

        if (!hasUppercase) {
            return "Password must contain at least 1 uppercase letter!";
        }

        if (!hasSpecialChar) {
            return "Password must contain at least 1 special character (!@#$%^&*()_+-=[]{}|;:,.<>?)";
        }

        return null; // Valid
    }

    /**
     * Hash a plain text password using BCrypt
     *
     * @param plainPassword The plain text password to hash
     * @return The hashed password (includes salt)
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORK_FACTOR));
    }
    
    /**
     * Verify a plain text password against a hashed password
     * 
     * @param plainPassword The plain text password to verify
     * @param hashedPassword The hashed password to check against
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Invalid hash format
            return false;
        }
    }
    
    /**
     * Check if a password needs to be rehashed (e.g., if work factor has changed)
     * 
     * @param hashedPassword The hashed password to check
     * @return true if the password should be rehashed, false otherwise
     */
    public static boolean needsRehash(String hashedPassword) {
        if (hashedPassword == null || hashedPassword.isEmpty()) {
            return true;
        }
        
        try {
            // Extract the work factor from the hash
            String[] parts = hashedPassword.split("\\$");
            if (parts.length < 4) {
                return true;
            }
            
            int currentWorkFactor = Integer.parseInt(parts[2]);
            return currentWorkFactor < WORK_FACTOR;
        } catch (Exception e) {
            return true;
        }
    }
}

