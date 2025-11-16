import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailService {
  // Resend.com email API (free service for sending emails)
  // Sign up at https://resend.com to get your API key
  static const String _apiKey = 're_U3xMxDWm_Kfn5NwXmgDQS5FwQgxRT2dNU';
  static const String _apiUrl = 'https://api.resend.com/emails';
  static const String _senderEmail =
      'onboarding@resend.dev'; // Default Resend sender
  static const String _senderName = 'FlyQuest Support';

  /// Generates a random 6-digit reset code
  static String generateResetCode() {
    Random random = Random();
    int code = 100000 + random.nextInt(900000);
    return code.toString();
  }

  /// Generates a secure token for password reset
  static String generateResetToken() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(
      32,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Sends a password reset email with a reset link
  static Future<Map<String, dynamic>> sendPasswordResetEmail(
    String recipientEmail,
    String recipientName,
    String resetCode,
  ) async {
    try {
      // Create email HTML
      String htmlContent =
          '''
        <html>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px;">
              <h2 style="color: #000080;">FlyQuest Password Reset</h2>
              
              <p>Hi $recipientName,</p>
              
              <p>We received a request to reset the password for your FlyQuest account. Use this code to reset your password:</p>
              
              <div style="text-align: center; margin: 20px 0;">
                <div style="background-color: #FFD700; color: #000080; padding: 15px; border-radius: 5px; font-weight: bold; font-size: 24px; letter-spacing: 2px;">
                  $resetCode
                </div>
              </div>
              
              <p><strong>Important:</strong></p>
              <ul>
                <li>This code is valid for 15 minutes only.</li>
                <li>Do not share this code with anyone.</li>
                <li>If you did not request this reset, please ignore this email.</li>
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

      // Send via Resend API
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': '$_senderName <$_senderEmail>',
          'to': recipientEmail,
          'subject': 'FlyQuest - Password Reset Code',
          'html': htmlContent,
        }),
      );

      print('📧 Password Reset Email');
      print('   To: $recipientEmail');
      print('   Reset Code: $resetCode');
      print('   API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Password reset email sent successfully');
        return {
          'success': true,
          'resetCode': resetCode,
          'message': 'Password reset code sent to $recipientEmail',
        };
      } else {
        print('❌ Email API error: ${response.body}');
        return {
          'success': false,
          'error': 'Failed to send email. Please try again later.',
        };
      }
    } catch (e) {
      print('❌ Error sending password reset email: $e');
      return {'success': false, 'error': 'Failed to send reset email: $e'};
    }
  }

  /// Sends a booking confirmation email with receipt and booking reference
  static Future<Map<String, dynamic>> sendBookingConfirmationEmail({
    required String recipientEmail,
    required String recipientName,
    required String bookingReference,
    required String origin,
    required String destination,
    required String departureDate,
    required String? returnDate,
    required String guestName,
    required String tripType,
    required String selectedBundle,
    required double totalPrice,
    required String paymentMethod,
  }) async {
    try {
      // Calculate pricing
      double subtotal = totalPrice * 0.95;
      double taxes = totalPrice * 0.05;

      // Create email HTML
      String htmlContent =
          '''
        <html>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px;">
              <div style="text-align: center; margin-bottom: 30px;">
                <h2 style="color: #000080; margin: 0;">FlyQuest</h2>
                <p style="color: #999; margin: 5px 0 0 0;">Flight Booking Confirmation</p>
              </div>
              
              <h2 style="color: #000080;">Booking Confirmed!</h2>
              
              <p>Hi $recipientName,</p>
              
              <p>Thank you for booking with FlyQuest! Your flight has been successfully booked. Here are your booking details:</p>
              
              <div style="background-color: #f9f9f9; padding: 20px; border-left: 4px solid #FFD700; margin: 20px 0; border-radius: 5px;">
                <p style="margin: 0 0 10px 0;"><strong>Booking Reference:</strong></p>
                <p style="font-size: 24px; color: #FFD700; font-weight: bold; margin: 0 0 20px 0;">$bookingReference</p>
                
                <p style="margin: 0 0 5px 0;"><strong>Passenger Name:</strong> $guestName</p>
                <p style="margin: 0 0 5px 0;"><strong>Route:</strong> $origin → $destination</p>
                <p style="margin: 0 0 5px 0;"><strong>Trip Type:</strong> $tripType</p>
                <p style="margin: 0 0 5px 0;"><strong>Departure:</strong> $departureDate</p>
                ${returnDate != null ? '<p style="margin: 0 0 5px 0;"><strong>Return:</strong> $returnDate</p>' : ''}
                <p style="margin: 0 0 5px 0;"><strong>Selected Bundle:</strong> $selectedBundle</p>
              </div>
              
              <div style="background-color: #f0f0f0; padding: 15px; border-radius: 5px; margin: 20px 0;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                  <span><strong>Subtotal:</strong></span>
                  <span>₱${subtotal.toStringAsFixed(2)}</span>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                  <span><strong>Taxes & Fees:</strong></span>
                  <span>₱${taxes.toStringAsFixed(2)}</span>
                </div>
                <div style="border-top: 2px solid #ddd; padding-top: 10px; display: flex; justify-content: space-between;">
                  <span style="font-size: 18px; font-weight: bold;"><strong>Total Paid:</strong></span>
                  <span style="font-size: 18px; font-weight: bold; color: #000080;">₱${totalPrice.toStringAsFixed(2)}</span>
                </div>
              </div>
              
              <p><strong>Payment Method:</strong> $paymentMethod</p>
              
              <p style="background-color: #fff3cd; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107;">
                <strong>Important:</strong> Please save your booking reference number. You will need it for check-in and any future communications regarding this booking.
              </p>
              
              <p><strong>What's Next?</strong></p>
              <ul>
                <li>Check your email for your flight details and boarding pass</li>
                <li>Arrive at the airport at least 2 hours before departure</li>
                <li>Keep your booking reference handy</li>
              </ul>
              
              <p>If you have any questions, please don't hesitate to contact us at support@flyquest.com</p>
              
              <p>Best regards,<br><strong>FlyQuest Team</strong></p>
              
              <hr style="border: none; border-top: 1px solid #ddd; margin-top: 20px;">
              <p style="font-size: 12px; color: #999; text-align: center;">
                This is an automated email. Please do not reply to this message.
              </p>
            </div>
          </body>
        </html>
      ''';

      // Send via Resend API
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': '$_senderName <$_senderEmail>',
          'to': recipientEmail,
          'subject': 'FlyQuest - Booking Confirmation #$bookingReference',
          'html': htmlContent,
        }),
      );

      print('📧 Booking Confirmation Email');
      print('   To: $recipientEmail');
      print('   Reference: $bookingReference');
      print('   API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Booking confirmation email sent successfully');
        return {
          'success': true,
          'message': 'Booking confirmation sent to $recipientEmail',
        };
      } else {
        print('❌ Email API error: ${response.body}');
        return {
          'success': false,
          'error': 'Failed to send booking confirmation email.',
        };
      }
    } catch (e) {
      print('❌ Error sending booking confirmation email: $e');
      return {'success': false, 'error': 'Failed to send booking email: $e'};
    }
  }
}
