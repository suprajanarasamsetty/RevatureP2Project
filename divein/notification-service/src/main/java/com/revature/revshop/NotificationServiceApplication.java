package com.revature.revshop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

import com.revature.revshop.event.OrderEvent;

@SpringBootApplication
public class NotificationServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(NotificationServiceApplication.class, args);
	}

	@Autowired
	private JavaMailSender mailSender;

	// Method to send email
	public void sendEmail(String to, String subject, String body) {
		SimpleMailMessage message = new SimpleMailMessage();
		message.setFrom("DIVEIN@demomailtrap.com");
		message.setTo(to);
		message.setSubject(subject);
		message.setText(body);
		
		mailSender.send(message);
	}

	// Listen for Kafka events and send email
	@KafkaListener(topics = "notificationTopic")
	public void getOrderEvent(OrderEvent orderEvent) {
		System.out.println("Received event: " + orderEvent.toString());

		// Customize the email body with order details
		String emailBody = "Thank you for shopping with us!\n\n" +
				"Your order has been placed successfully. \n" +
				"Order Number: " + orderEvent.getOrderNumber() + "\n\n" +
				"We hope you are satisfied with our service.\n" +
				"Please reach out if you need any further assistance.\n\n" +
				"Contact Email : DiveIn@Ecommerce.in.com\n\n" +
				"Best regards,\n" +
				"DIVEIN Team";

		// Send the email
		sendEmail("saijakkula021@gmail.com", "DIVEIN: Order Confirmation", emailBody);
	}
}
