<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sales Pending Import</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sales.css">
    <style>
        .pending-box {
            border: 1px solid #ffeeba;
            background-color: #fffdf0;
            border-radius: 8px;
            width: 250px;
            margin: 20px auto;
            text-align: center;
            padding: 15px;
        }
        .pending-box .title {
            color: #d39e00;
            font-size: 14px;
            font-weight: bold;
            text-transform: uppercase;
        }
        .pending-box .count {
            color: #bd2130;
            font-size: 32px;
            font-weight: bold;
            margin-top: 5px;
        }
        .filter-section {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        .btn-sort, .select-custom {
            padding: 8px 16px;
            border: 1px solid #ced4da;
            background: #fff;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-process {
            background-color: #0b4a3a;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-process:hover {
            background-color: #083628;
        }
    </style>
</head>
<body>

<c:set var="activePage" value="imports"/>
<jsp:include page="../common/header-sales.jsp"/>

<div class="main">
    <div class="card">

        <div class="pending-box">
            <div class="title">Pending Imports</div>
            <div class="count">${pendingCount}</div>
        </div>

        <div class="filter-section">
            <button class="btn-sort">Supplier Sort</button>
            <select class="select-custom">
                <option>Latest</option>
                <option>Oldest</option>
            </select>
        </div>

        <table>
            <thead>
            <tr>
                <th>PO ID</th>
                <th>Supplier Name</th>
                <th>Total Expected Quantity</th>
                <th>Order Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="receipt" items="${receipts}">
                <tr>
                    <td><strong>${receipt.importIdDisplay}</strong></td>
                    <td>${receipt.supplierName}</td>
                    <td>${receipt.totalExpectedQuantity} (Số lượng)</td>
                    <td>${receipt.createdDateDisplay}</td>
                    <td>
                        <c:choose>
                            <c:when test="${receipt.statusKey == 'pending'}">
                                <span class="badge badge-pending">Pending</span>
                            </c:when>
                            <c:when test="${receipt.statusKey == 'received'}">
                                <span class="badge badge-confirmed">Received</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge">${receipt.dbStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <button class="btn-process" onclick="window.location.href='${pageContext.request.contextPath}/sales/imports/process?id=${receipt.importReceiptId}'">
                            Process &rarr;
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty receipts}">
                <tr><td colspan="6" style="text-align:center;color:#aaa;padding:30px;">Không có phiếu nhập hàng nào chờ xử lý</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>