package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.request.ImportReceiptDetailRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptDetailResponse;

import java.math.BigDecimal;
import java.util.List;

public interface ImportReceiptDetailService {

    List<ImportReceiptDetailResponse> createDetails(Integer importReceiptId,
                                                    List<ImportReceiptDetailRequest> requests);
    List<ImportReceiptDetailResponse> getDetailsByReceiptId(Integer importReceiptId);

    ImportReceiptDetailResponse getDetailById(Integer importDetailId);

    List<ImportReceiptDetailResponse> updateDetails(Integer importReceiptId,
                                                    List<ImportReceiptDetailRequest> requests);
    void deleteDetail(Integer importDetailId);

    void deleteAllByReceiptId(Integer importReceiptId);

    BigDecimal sumTotalExpectedQuantity();

    BigDecimal sumSubtotalByReceiptId(Integer importReceiptId);

    boolean isProductExistsInReceipt(Integer importReceiptId, Integer productId);
}