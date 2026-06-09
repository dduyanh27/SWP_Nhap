package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.response.BatchGroupResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchStatsResponse;

import java.util.List;

public interface AdminBatchService {
    List<BatchGroupResponse> getBatchManagementData();

    BatchStatsResponse getBatchStats();
}