<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tài khoản của tôi - VMFRUIT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/profile.css'/>">
</head>
<body class="bg-light">

<jsp:include page="common/header.jsp" />

<div class="container mt-3 mb-3">
    <small class="text-muted">Trang chủ / <b>Tài khoản của tôi</b></small>
</div>

<main class="container mb-5">

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show mt-2" role="alert">
            ✓ ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show mt-2" role="alert">
            ✗ ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-md-3 mb-4">
            <jsp:include page="common/profile-left.jsp" />
        </div>

        <div class="col-md-9">
            <c:choose>

                <c:when test="${empty param.tab or param.tab eq 'profile'}">
                    <div class="profile-card">
                        <div class="mb-4 border-bottom pb-3">
                            <h4 class="mb-1 fw-bold">Hồ Sơ Của Tôi</h4>
                            <p class="text-muted mb-0">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/profile/update" method="POST" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-8 border-end pe-4">
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Họ và tên</label>
                                        <input type="text" class="form-control w-75" name="fullName" value="${user.fullName}" required>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Email</label>
                                        <input type="email" class="form-control w-75" value="${user.email}" disabled>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Số điện thoại</label>
                                        <input type="text" class="form-control w-75" name="phone" value="${user.phone}" required>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Giới tính</label>
                                        <div class="w-75 d-flex gap-4 pt-2">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="gender" value="Nam" id="genderMale" ${user.gender eq 'Nam' ? 'checked' : ''}>
                                                <label class="form-check-label" for="genderMale">Nam</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="gender" value="Nữ" id="genderFemale" ${user.gender eq 'Nữ' ? 'checked' : ''}>
                                                <label class="form-check-label" for="genderFemale">Nữ</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="gender" value="Khác" id="genderOther" ${user.gender eq 'Khác' ? 'checked' : ''}>
                                                <label class="form-check-label" for="genderOther">Khác</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mb-4 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Ngày sinh</label>
                                        <input type="date"
                                               class="form-control w-75"
                                               name="dateOfBirth"
                                               value="${user.dateOfBirth}">
                                    </div>
                                    <div class="d-flex">
                                        <div class="w-25"></div>
                                        <button type="submit" class="btn btn-success px-4">LƯU THAY ĐỔI</button>
                                    </div>
                                </div>

                                <div class="col-md-4 text-center">
                                    <div class="avatar-upload-section d-flex flex-column align-items-center">
                                        <div class="avatar-preview-container" style="width: 100px; height: 100px; margin-bottom: 15px;">
                                            <c:choose>
                                                <c:when test="${not empty user.avatarUrl}">
                                                    <img src="${user.avatarUrl}" id="avatarPreview" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="<c:url value='/asset/avatar/customer1.jpg'/>" id="avatarPreview" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                                                </c:otherwise>
                                            </c:choose>
                                    </div>
                                </div>
                            </div>
                        </form> </div>
                </c:when>
                <c:when test="${param.tab eq 'orders'}">
                    <div class="profile-card">
                        <div class="mb-4 border-bottom pb-3">
                            <h4 class="mb-1 fw-bold">Lịch sử đơn hàng</h4>
                            <p class="text-muted mb-0">Theo dõi trạng thái và chi tiết các đơn hàng.</p>
                        </div>

                        <ul class="nav nav-tabs mb-4 flex-nowrap overflow-auto">
                            <li class="nav-item"><a class="nav-link ${empty param.status ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?tab=orders">Tất cả</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'PENDING' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?tab=orders&status=PENDING">Chờ xác nhận</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'CONFIRMED' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?tab=orders&status=CONFIRMED">Xác nhận</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'DELIVERING' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?tab=orders&status=DELIVERING">Đang giao</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'COMPLETED' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?tab=orders&status=COMPLETED">Hoàn thành</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'CANCELLED' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?tab=orders&status=CANCELLED">Đã hủy</a></li>
                        </ul>

                        <c:choose>
                            <c:when test="${not empty orderList and orderList.size() > 0}">
                                <c:set var="hasOrders" value="false"/>
                                <c:forEach var="order" items="${orderList}">
                                    <c:if test="${empty param.status or order.orderStatus eq param.status}">
                                        <c:set var="hasOrders" value="true"/>
                                        <div class="card mb-3">
                                            <div class="card-body">
                                                <div class="row align-items-center">
                                                    <div class="col-md-3">
                                                        <strong>#Đơn ${order.orderId}</strong>
                                                        <br>
                                                        <small class="text-muted">${order.createdAt}</small>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div>Tổng tiền:</div>
                                                        <strong style="color: #198754; font-size: 18px;">
                                                                ${order.totalAmount != null ? order.totalAmount : 0} đ
                                                        </strong>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <span class="badge bg-${(order.orderStatus eq 'DELIVERED' or order.orderStatus eq 'COMPLETED') ? 'success' : (order.orderStatus eq 'PENDING' or order.orderStatus eq 'PENDING_APPROVAL') ? 'warning' : order.orderStatus eq 'CONFIRMED' ? 'primary' : (order.orderStatus eq 'SHIPPING' or order.orderStatus eq 'DELIVERING') ? 'info' : 'danger'}">
                                                                ${(order.orderStatus eq 'PENDING' or order.orderStatus eq 'PENDING_APPROVAL') ? 'Chờ xác nhận' : order.orderStatus eq 'CONFIRMED' ? 'Đã xác nhận' : (order.orderStatus eq 'SHIPPING' or order.orderStatus eq 'DELIVERING') ? 'Đang giao' : (order.orderStatus eq 'DELIVERED' or order.orderStatus eq 'COMPLETED') ? 'Hoàn thành' : 'Đã hủy'}
                                                        </span>
                                                    </div>
                                                    <div class="col-md-3 text-end">
                                                        <button type="button" class="btn btn-sm btn-primary"
                                                                onclick="openOrderDetails(${order.orderId})">
                                                            Chi tiết
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${not hasOrders}">
                                    <div class="alert alert-info mt-3">Không có đơn hàng nào ở trạng thái này.</div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mt-3">Bạn chưa có đơn hàng nào.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <c:when test="${param.tab eq 'address'}">
                    <div class="profile-card">
                        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                            <div>
                                <h4 class="mb-1 fw-bold">Địa chỉ của tôi</h4>
                                <p class="text-muted mb-0">Quản lý thông tin giao hàng</p>
                            </div>
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addressModal">
                                <i class="fas fa-plus"></i> Thêm địa chỉ mới
                            </button>
                        </div>

                        <c:choose>
                            <c:when test="${not empty addressList and addressList.size() > 0}">
                                <c:forEach var="address" items="${addressList}">
                                    <div class="card mb-3 ${address.isDefault ? 'border-success' : ''}">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <strong>${address.receiverName}</strong>
                                                    <c:if test="${address.isDefault}">
                                                        <span class="badge bg-success">Mặc định</span>
                                                    </c:if>
                                                    <br>
                                                    <small class="text-muted">📞 ${address.phone}</small>
                                                    <br>
                                                    <small>${address.fullAddress}</small>
                                                </div>
                                                <form method="POST" action="${pageContext.request.contextPath}/profile/address/delete/${address.addressId}" style="display: inline;">
                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn chắc chắn muốn xóa?')">
                                                        <i class="fas fa-trash"></i> Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mt-3">Bạn chưa có địa chỉ nào.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="modal fade" id="addressModal" tabindex="-1">
                        <div class="modal-dialog">
                            <form action="${pageContext.request.contextPath}/profile/address/add" method="POST" class="modal-content p-3">
                                <h5 class="mb-3">Thêm địa chỉ</h5>
                                <input type="text" name="receiverName" class="form-control mb-2" placeholder="Tên người nhận" required>
                                <input type="text" name="phone" class="form-control mb-2" placeholder="Số điện thoại" required>
                                <textarea name="fullAddress" class="form-control mb-3" placeholder="Địa chỉ đầy đủ (VD: 123 Đường ABC, Phường XYZ, Quận 1, TP.HCM)" rows="3" required></textarea>
                                <div class="form-check mb-3">
                                    <input type="checkbox" name="isDefault" value="1" class="form-check-input" id="isDefault">
                                    <label class="form-check-label" for="isDefault">Đặt làm địa chỉ mặc định</label>
                                </div>
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-success">Lưu địa chỉ</button>
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:when>

                <c:when test="${param.tab eq 'password'}">
                    <div class="profile-card">
                        <div class="mb-4 border-bottom pb-3">
                            <h4 class="mb-1 fw-bold">Đổi Mật Khẩu</h4>
                            <p class="text-muted mb-0">Vui lòng không chia sẻ mật khẩu cho người khác</p>
                        </div>
                        <div class="row">
                            <div class="col-md-8 offset-md-2">
                                <form action="${pageContext.request.contextPath}/profile/change-password" method="POST" onsubmit="return validatePass()">
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Mật khẩu cũ</label>
                                        <input type="password" name="oldPassword" class="form-control w-75" required>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Mật khẩu mới</label>
                                        <input type="password" name="newPassword" id="newPass" class="form-control w-75" required>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Xác nhận</label>
                                        <input type="password" name="confirmPassword" id="confPass" class="form-control w-75" required>
                                    </div>
                                    <div class="d-flex">
                                        <div class="w-25"></div>
                                        <button type="submit" class="btn btn-success px-4">Xác nhận</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:when test="${param.tab eq 'notification'}">
                    <div class="profile-card">
                        <div class="mb-4 border-bottom pb-3">
                            <h4 class="mb-1 fw-bold">Thông báo của tôi</h4>
                            <p class="text-muted mb-0">Cập nhật các hoạt động mới nhất từ VMFRUIT</p>
                        </div>
                        <c:choose>
                            <c:when test="${not empty notificationList and notificationList.size() > 0}">
                                <c:forEach var="notification" items="${notificationList}">
                                    <div class="card mb-3 ${!notification.isRead ? 'border-left border-success' : ''}">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <strong>${notification.title}</strong>
                                                    <c:if test="${!notification.isRead}">
                                                        <span class="badge bg-success">Mới</span>
                                                    </c:if>
                                                    <br>
                                                    <p class="mb-1">${notification.message}</p>
                                                    <small class="text-muted">${notification.createdAt}</small>
                                                </div>
                                                <span class="badge bg-info">${notification.type}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mt-3">
                                    <i class="fas fa-bell"></i> Chưa có thông báo mới
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
            </c:choose>
        </div> </div> </main>


<div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="orderDetailsModalLabel">Chi tiết đơn hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="orderInfo" class="mb-4 p-3 bg-light rounded">
                    <p><strong>ID Đơn:</strong> <span id="orderId"></span></p>
                    <p><strong>Trạng thái:</strong> <span id="orderStatus"></span></p>
                    <p><strong>Tổng tiền:</strong> <span id="totalAmount" style="color: #198754; font-size: 18px;"></span></p>
                </div>

                <h6 class="mb-3">Danh sách sản phẩm:</h6>
                <table class="table table-bordered table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>Sản phẩm</th>
                        <th class="text-center">Số lượng</th>
                        <th class="text-end">Giá</th>
                        <th class="text-end">Tổng</th>
                    </tr>
                    </thead>
                    <tbody id="orderItems">
                    <tr>
                        <td colspan="4" class="text-center text-muted">Đang tải...</td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>

    function previewImage(event) {
        var reader = new FileReader();
        reader.onload = function(){
            document.getElementById('avatarPreview').src = reader.result;
        };
        if(event.target.files[0]) reader.readAsDataURL(event.target.files[0]);
    }

    // Validate Đổi mật khẩu
    function validatePass() {
        const newPass = document.getElementById("newPass").value;
        const confPass = document.getElementById("confPass").value;

        if(newPass !== confPass) {
            alert("Mật khẩu mới không khớp!");
            return false;
        }

        if(newPass.length < 8) {
            alert("Mật khẩu phải có tối thiểu 8 ký tự!");
            return false;
        }
        return true;
    }
    function openOrderDetails(orderId) {
        fetch('/profile/orders/' + orderId + '/details')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Mã lỗi HTTP: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                // Điền thông tin đơn hàng
                document.getElementById("orderId").textContent = data.orderId || ('#' + orderId);
                document.getElementById("orderStatus").textContent = data.orderStatus || 'N/A';
                document.getElementById("totalAmount").textContent =
                    (data.totalAmount ? data.totalAmount.toLocaleString('vi-VN') + ' đ' : '0 đ');

                // Điền danh sách sản phẩm
                let itemsHtml = '';
                if (data.items && data.items.length > 0) {
                    data.items.forEach(item => {
                        let priceStr = item.unitPrice ? item.unitPrice.toLocaleString('vi-VN') : '0';
                        let totalStr = item.lineTotal ? item.lineTotal.toLocaleString('vi-VN') : '0';

                        // Dùng nối chuỗi để JSP không ăn mất biến item
                        itemsHtml += '<tr>' +
                            '<td><strong>' + item.productName + '</strong></td>' +
                            '<td class="text-center">' + item.quantity + '</td>' +
                            '<td class="text-end">' + priceStr + ' đ</td>' +
                            '<td class="text-end"><strong>' + totalStr + ' đ</strong></td>' +
                            '</tr>';
                    });
                } else {
                    itemsHtml = '<tr><td colspan="4" class="text-center text-muted">Không có sản phẩm nào</td></tr>';
                }

                document.getElementById("orderItems").innerHTML = itemsHtml;

                // Hiển thị modal
                const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Lỗi API:', error);
                alert('Không thể tải chi tiết đơn hàng. Vui lòng thử lại sau!\nChi tiết: ' + error.message);
            });
    }
</script>

<jsp:include page="common/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
