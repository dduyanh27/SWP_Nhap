<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sales Import Process</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            background: #1f1f1f;
            color: #344256;
            font-family: Arial, sans-serif;
        }

        .sip-screen-label {
            width: min(1114px, calc(100vw - 48px));
            margin: 18px auto 8px;
            color: #6f6f6f;
            font-size: 13px;
            font-weight: 700;
        }

        .sip-page {
            width: min(1114px, calc(100vw - 48px));
            margin: 0 auto 18px;
            background: #f3f5f7;
            border: 2px solid #149dff;
        }

        .sip-header {
            min-height: 72px;
            background: #064f35;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            padding: 0 30px;
        }

        .sip-title {
            font-size: 21px;
            font-weight: 800;
            line-height: 1.25;
        }

        .sip-user-actions {
            display: flex;
            align-items: center;
            gap: 28px;
            flex-shrink: 0;
        }

        .sip-staff-badge {
            min-width: 162px;
            min-height: 36px;
            border-radius: 18px;
            background: #0d6b4d;
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 18px;
            font-size: 13px;
            font-weight: 800;
        }

        .sip-logout {
            color: #fff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 800;
        }

        .sip-breadcrumb {
            min-height: 52px;
            background: #fff;
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 0 30px;
            color: #627086;
            font-size: 14px;
            font-weight: 800;
        }

        .sip-breadcrumb a {
            color: #627086;
            text-decoration: none;
        }

        .sip-breadcrumb strong {
            color: #064f35;
        }

        .sip-content {
            padding: 24px 30px 30px;
        }

        .sip-panel {
            min-height: 656px;
            background: #fff;
            border-radius: 8px;
            padding: 30px;
        }

        .sip-summary {
            border: 1px solid #d9e3ef;
            border-radius: 7px;
            background: #f8fbff;
            display: grid;
            grid-template-columns: 1.3fr 1fr;
            gap: 12px 40px;
            padding: 16px 20px;
            margin-bottom: 24px;
        }

        .sip-summary span {
            color: #65748b;
            font-size: 13px;
            font-weight: 800;
            margin-right: 6px;
        }

        .sip-summary strong {
            color: #111827;
            font-size: 14px;
        }

        .sip-summary .sip-normal {
            color: #405069;
            font-weight: 500;
        }

        .sip-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .sip-table {
            width: 100%;
            border-collapse: collapse;
        }

        .sip-table thead tr {
            background: #eef3f8;
        }

        .sip-table th,
        .sip-table td {
            border-bottom: 1px solid #edf1f5;
            padding: 15px 20px;
            text-align: left;
            vertical-align: middle;
            white-space: nowrap;
        }

        .sip-table th {
            color: #304054;
            font-size: 13px;
            font-weight: 800;
        }

        .sip-table th:first-child {
            border-top-left-radius: 5px;
        }

        .sip-table th:last-child {
            border-top-right-radius: 5px;
        }

        .sip-fruit-name {
            color: #111827;
            font-weight: 800;
        }

        .sip-qty-box {
            width: 114px;
            height: 38px;
            border: 1px solid #cbd8e7;
            border-radius: 5px;
            background: #fff;
            display: inline-flex;
            align-items: center;
            overflow: hidden;
        }

        .sip-qty-box:focus-within {
            border-color: #064f35;
            box-shadow: 0 0 0 2px rgba(6, 79, 53, 0.1);
        }

        .sip-actual-input {
            width: 72px;
            height: 100%;
            border: none;
            outline: none;
            color: #111827;
            font-size: 15px;
            font-weight: 800;
            text-align: center;
        }

        .sip-qty-box span {
            color: #6b778c;
            font-size: 13px;
            padding-right: 8px;
        }

        .sip-loss-pill {
            min-width: 64px;
            border-radius: 5px;
            display: inline-flex;
            justify-content: center;
            gap: 4px;
            padding: 5px 10px;
            font-size: 13px;
            font-weight: 800;
        }

        .sip-loss-pill.is-zero {
            background: #dcfce7;
            color: #008448;
        }

        .sip-loss-pill.has-loss {
            background: #ffe3e3;
            color: #c91919;
        }

        .sip-date-input {
            width: 164px;
            height: 38px;
            border: 1px solid #cbd8e7;
            border-radius: 5px;
            color: #111827;
            padding: 0 12px;
            font-size: 14px;
        }

        .sip-note-label {
            display: block;
            margin: 26px 0 8px;
            color: #405069;
            font-size: 13px;
            font-weight: 800;
        }

        .sip-note {
            width: 100%;
            min-height: 62px;
            border: 1px solid #cbd8e7;
            border-radius: 5px;
            resize: vertical;
            color: #344256;
            font-family: Arial, sans-serif;
            font-size: 14px;
            padding: 12px 16px;
        }

        .sip-note::placeholder {
            color: #9badc3;
        }

        .sip-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-top: 40px;
        }

        .sip-back,
        .sip-confirm {
            min-height: 48px;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 18px;
            text-decoration: none;
            font-weight: 800;
            cursor: pointer;
        }

        .sip-back {
            min-width: 142px;
            border: 1px solid #aebdd0;
            background: #fff;
            color: #405069;
        }

        .sip-confirm {
            min-width: 264px;
            border: 1px solid #064f35;
            background: #064f35;
            color: #fff;
            font-size: 14px;
        }

        @media (max-width: 800px) {
            .sip-screen-label,
            .sip-page {
                width: calc(100vw - 24px);
            }

            .sip-header {
                align-items: flex-start;
                flex-direction: column;
                padding: 18px;
            }

            .sip-title {
                font-size: 18px;
            }

            .sip-breadcrumb {
                align-items: flex-start;
                flex-direction: column;
                gap: 6px;
                padding: 14px 18px;
            }

            .sip-content,
            .sip-panel {
                padding: 18px;
            }

            .sip-summary {
                grid-template-columns: 1fr;
            }

            .sip-actions {
                align-items: stretch;
                flex-direction: column;
            }

            .sip-back,
            .sip-confirm {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="sip-screen-label">Sales Import Process</div>

<main class="sip-page">
    <header class="sip-header">
        <div class="sip-title">VMFRUIT POS - INBOUND INSPECTION &amp; WASTAGE CONTROL</div>
        <div class="sip-user-actions">
            <span class="sip-staff-badge">Staff: ${empty user.fullName ? 'Nguyen Van A' : user.fullName}</span>
            <a class="sip-logout" href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </header>

    <nav class="sip-breadcrumb">
        <a href="${pageContext.request.contextPath}/sales/imports">PENDING IMPORTS QUEUE</a>
        <span>/</span>
        <strong>PROCESSING PURCHASE ORDER ${importProcess.importIdDisplay}</strong>
    </nav>

    <section class="sip-content">
        <div class="sip-panel">
            <div class="sip-summary">
                <div>
                    <span>Supplier:</span>
                    <strong>${importProcess.supplierName}</strong>
                </div>
                <div>
                    <span>Total Expected Varieties:</span>
                    <strong><fmt:formatNumber value="${importProcess.totalExpectedVarieties}" minIntegerDigits="2"/> Products</strong>
                </div>
                <div>
                    <span>Created Date:</span>
                    <strong class="sip-normal">${importProcess.createdDateDisplay}</strong>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div style="margin-bottom:16px;color:#b42318;font-weight:700;">${errorMessage}</div>
            </c:if>

            <form class="sip-form" action="${pageContext.request.contextPath}/sales/imports/process" method="post">
                <input type="hidden" name="importReceiptId" value="${importProcess.importReceiptId}">

                <div class="sip-table-wrap">
                    <table class="sip-table">
                        <thead>
                        <tr>
                            <th>Fruit Product</th>
                            <th>Expected Qty</th>
                            <th>Actual Received</th>
                            <th>Wastage (Loss)</th>
                            <th>TTL / Expiry Date</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${importProcess.items}">
                            <tr class="sip-row">
                                <td class="sip-fruit-name">
                                    ${item.productName}
                                    <input type="hidden" name="importDetailIds" value="${item.importDetailId}">
                                </td>
                                <td>
                                    <fmt:formatNumber value="${item.expectedQuantity}" maxFractionDigits="2"/>
                                    ${item.unit}
                                </td>
                                <td>
                                    <label class="sip-qty-box">
                                        <input class="sip-actual-input"
                                               name="actualQuantities"
                                               type="number"
                                               min="0"
                                               step="0.01"
                                               value="${item.expectedQuantity}"
                                               data-expected="${item.expectedQuantity}"
                                               required>
                                        <span>${item.unit}</span>
                                    </label>
                                </td>
                                <td>
                                    <span class="sip-loss-pill is-zero"><span class="sip-loss-value">0</span> ${item.unit}</span>
                                </td>
                                <td><input class="sip-date-input" name="expiryDates" type="date" value="${item.expiryDateValue}" required></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <label class="sip-note-label" for="inspectionNote">Inspection Note / Discrepancy Reason:</label>
                <textarea class="sip-note" id="inspectionNote" name="inspectionNote" placeholder="e.g., 10kg of Xoai Cat Chu damaged due to transit compression..."></textarea>

                <div class="sip-actions">
                    <a class="sip-back" href="${pageContext.request.contextPath}/sales/imports">&larr; Back to Queue</a>
                    <button class="sip-confirm" type="submit">Confirm &amp; Activate Lots &rarr;</button>
                </div>
            </form>
        </div>
    </section>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.sip-row').forEach(function (row) {
            const actualInput = row.querySelector('.sip-actual-input');
            const lossPill = row.querySelector('.sip-loss-pill');
            const lossValue = row.querySelector('.sip-loss-value');

            function formatQuantity(quantity) {
                if (Number.isInteger(quantity)) {
                    return String(quantity);
                }
                return quantity.toFixed(2).replace(/\.?0+$/, '');
            }

            function updateLoss() {
                const expected = Number.parseFloat(actualInput.dataset.expected || '0');
                const actual = Number.parseFloat(actualInput.value || '0');
                const loss = Math.max(expected - actual, 0);
                const formatted = formatQuantity(loss);

                lossValue.textContent = formatted;
                lossPill.classList.toggle('is-zero', loss === 0);
                lossPill.classList.toggle('has-loss', loss > 0);
            }

            actualInput.addEventListener('input', updateLoss);
            updateLoss();
        });
    });
</script>

</body>
</html>
