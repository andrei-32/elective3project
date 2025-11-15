import 'dart:math';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart' as smtp;

class EmailService {
  // Gmail SMTP configuration
  static const String _senderEmail =
      'your-email@gmail.com'; // Replace with your email
  static const String _appPassword =
      'your-app-password'; // Replace with your app password
  static const String _senderName = 'FlyQuest Support';

  /// Generates a random 6-digit reset code
  static String generateResetCode() {
    Random random = Random();
    int code = 100000 + random.nextInt(900000);
    return code.toString();
  }

  /// Sends a password reset email with a temporary code
  static Future<bool> sendPasswordResetEmail(
    String recipientEmail,
    String recipientName,
    String resetCode,
  ) async {
    try {
      // Gmail SMTP server
      final smtpServer = smtp.gmail(_senderEmail, _appPassword);

      // Create email message
      final message = mailer.Message()
        ..from = mailer.Address(_senderEmail, _senderName)
        ..recipients.add(recipientEmail)
        ..subject = 'FlyQuest - Password Reset Request'
        ..html =
            '''
          <html>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
              <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px;">
                <h2 style="color: #000080;">FlyQuest Password Reset</h2>
                
                <p>Hi $recipientName,</p>
                
                <p>We received a request to reset the password for your FlyQuest account. Use the code below to reset your password:</p>
                
                <div style="background-color: #f0f0f0; padding: 15px; text-align: center; margin: 20px 0; border-radius: 5px;">
                  <h1 style="color: #FFD700; font-size: 32px; letter-spacing: 3px; margin: 0;">$resetCode</h1>
                </div>
                
                <p><strong>Important:</strong></p>
                <ul>
                  <li>This code is valid for 15 minutes only.</li>
                  <li>Do not share this code with anyone.</li>
                  <li>If you did not request this reset, please ignore this email and your password will remain unchanged.</li>
                </ul>
                
                <p>If you have any questions, please contact our support team at support@flyquest.com</p>
                
                <p>Best regards,<br><strong>FlyQuest Team</strong></p>
                
                <hr style="border: none; border-top: 1px solid #ddd; margin-top: 20px;">
                <p style="font-size: 12px; color: #999;">
                  This is an automated email. Please do not reply to this message.
                </p>
              </div>
            </body>
          </html>
        ''';

      // Send email
      await mailer.send(message, smtpServer);
      return true;
    } catch (e) {
      // Email sending failed silently
      return false;
    }
  }

  /// Sends a new temporary password via email
  static Future<bool> sendTemporaryPassword(
    String recipientEmail,
    String recipientName,
    String temporaryPassword,
  ) async {
    try {
      final smtpServer = smtp.gmail(_senderEmail, _appPassword);

      final message = mailer.Message()
        ..from = mailer.Address(_senderEmail, _senderName)
        ..recipients.add(recipientEmail)
        ..subject = 'FlyQuest - Your Temporary Password'
        ..html =
            '''
          <html>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
              <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px;">
                <h2 style="color: #000080;">FlyQuest Password Reset</h2>
                
                <p>Hi $recipientName,</p>
                
                <p>Your password has been reset. Use this temporary password to log in:</p>
                
                <div style="background-color: #f0f0f0; padding: 15px; text-align: center; margin: 20px 0; border-radius: 5px;">
                  <p style="font-size: 18px; color: #000080; margin: 0; word-break: break-all;"><strong>$temporaryPassword</strong></p>
                </div>
                
                <p><strong>Important:</strong></p>
                <ul>
                  <li>Please change this password immediately after logging in.</li>
                  <li>Do not share this password with anyone.</li>
                </ul>
                
                <p>If you have any questions, please contact our support team at support@flyquest.com</p>
                
                <p>Best regards,<br><strong>FlyQuest Team</strong></p>
                
                <hr style="border: none; border-top: 1px solid #ddd; margin-top: 20px;">
                <p style="font-size: 12px; color: #999;">
                  This is an automated email. Please do not reply to this message.
                </p>
              </div>
            </body>
          </html>
        ''';

      await mailer.send(message, smtpServer);
      return true;
    } catch (e) {
      // Email sending failed silently
      return false;
    }
  }
}
