package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.Notification;
import java.util.List;

public interface NotificationService {
    List<Notification> getNotificationsByUser(Integer userId);
    long countUnreadNotifications(Integer userId);
    void markAsRead(Integer notificationId);

    void createNotification(Integer userId, String title, String message, String type);
    void deleteNotification(Integer notificationId);
}