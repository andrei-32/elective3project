import 'dart:convert';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // ⚠️ REPLACE WITH YOUR ACTUAL GMAIL CREDENTIALS ⚠️
  static const String _gmailAddress = 'elijarodriguez1@gmail.com';
  static const String _gmailAppPassword = 'rqknisdlklakdhih'; // Generate from Google Account

  // Gmail SMTP server
  static final SmtpServer _smtpServer = SmtpServer(
    'smtp.gmail.com',
    username: _gmailAddress,
    password: _gmailAppPassword,
    port: 587,
    ssl: false,
    allowInsecure: true,
  );

  static String generateResetCode() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  static Future<Map<String, dynamic>> sendPasswordResetEmail(
    String recipientEmail,
    String recipientName,
    String resetCode,
  ) async {
    try {
      print('🚀 SENDING PASSWORD RESET EMAIL...');
      print('   From: $_gmailAddress');
      print('   To: $recipientEmail');

      // Validate credentials
      if (_gmailAddress.contains('your-email') || _gmailAppPassword.contains('your-16-character')) {
        throw Exception('Please configure Gmail credentials in EmailService');
      }

      final message = Message()
        ..from = Address(_gmailAddress, 'FlyQuest Support')
        ..recipients.add(recipientEmail)
        ..subject = 'FlyQuest - Password Reset Code'
        ..html = '''
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #2563eb;">FlyQuest Password Reset</h2>
            <p>Hi $recipientName,</p>
            <p>You requested a password reset. Your reset code is:</p>
            <div style="background-color: #f3f4f6; padding: 16px; text-align: center; margin: 20px 0;">
              <strong style="font-size: 24px; color: #2563eb;">$resetCode</strong>
            </div>
            <p>This code will expire in 15 minutes.</p>
            <p>If you didn't request this reset, please ignore this email.</p>
            <br>
            <p>Best regards,<br>FlyQuest Team</p>
          </div>
        ''';

      final sendReport = await send(message, _smtpServer);
      print('✅ PASSWORD RESET EMAIL SENT SUCCESSFULLY!');
      
      return {
        'success': true,
        'resetCode': resetCode,
        'message': 'Password reset code sent to $recipientEmail',
      };
    } catch (e) {
      print('❌ EMAIL SENDING ERROR: $e');
      return {
        'success': false, 
        'error': 'Failed to send email: $e. Please check your email configuration.'
      };
    }
  }

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
      print('🚀 SENDING BOOKING CONFIRMATION EMAIL...');
      print('   To: $recipientEmail');

      // Validate credentials
      if (_gmailAddress.contains('your-email') || _gmailAppPassword.contains('your-16-character')) {
        throw Exception('Please configure Gmail credentials in EmailService');
      }

      final returnInfo = returnDate != null ? 
        '<p><strong>Return Date:</strong> $returnDate</p>' : 
        '<p><strong>Trip Type:</strong> One-way</p>';

      final message = Message()
        ..from = Address(_gmailAddress, 'FlyQuest Booking')
        ..recipients.add(recipientEmail)
        ..subject = 'FlyQuest Booking Confirmation - #$bookingReference'
        ..html = '''
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #2563eb;">Booking Confirmed! 🎉</h2>
            <p>Hi $recipientName,</p>
            
            <div style="background-color: #f8fafc; padding: 20px; border-radius: 8px; margin: 20px 0;">
              <h3 style="color: #2563eb; margin-top: 0;">Booking Details</h3>
              <p><strong>Booking Reference:</strong> $bookingReference</p>
              <p><strong>Passenger:</strong> $guestName</p>
              <p><strong>Route:</strong> $origin to $destination</p>
              <p><strong>Departure Date:</strong> $departureDate</p>
              $returnInfo
              <p><strong>Bundle:</strong> $selectedBundle</p>
              <p><strong>Payment Method:</strong> $paymentMethod</p>
              <hr style="margin: 16px 0;">
              <p style="font-size: 18px; font-weight: bold;">
                <strong>Total Amount:</strong> ₱${totalPrice.toStringAsFixed(2)}
              </p>
            </div>
            
            <p>Thank you for choosing FlyQuest! We wish you a pleasant journey.</p>
            <br>
            <p>Best regards,<br>FlyQuest Team</p>
          </div>
        ''';

      final sendReport = await send(message, _smtpServer);
      print('✅ BOOKING CONFIRMATION EMAIL SENT SUCCESSFULLY!');
      
      return {
        'success': true, 
        'message': 'Booking confirmation sent to $recipientEmail'
      };
    } catch (e) {
      print('❌ BOOKING EMAIL ERROR: $e');
      return {
        'success': false, 
        'error': 'Failed to send booking confirmation: $e'
      };
    }
  }
}