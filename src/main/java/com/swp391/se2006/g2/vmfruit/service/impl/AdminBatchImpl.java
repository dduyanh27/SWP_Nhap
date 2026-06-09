package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.response.BatchGroupResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchItemResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchStatsResponse;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchRepository;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchItemsRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminBatchService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class AdminBatchImpl implements AdminBatchService {

    private final InboundBatchRepository inboundBatchRepository;
    private final InboundBatchItemsRepository inboundBatchItemsRepository;

    public AdminBatchImpl(InboundBatchRepository inboundBatchRepository,
                          InboundBatchItemsRepository inboundBatchItemsRepository) {
        this.inboundBatchRepository = inboundBatchRepository;
        this.inboundBatchItemsRepository = inboundBatchItemsRepository;
    }

    @Override
    public List<BatchGroupResponse> getBatchManagementData() {
        List<BatchGroupResponse> groups = inboundBatchRepository.getAllBatchGroups();

        for (BatchGroupResponse group : groups) {
            List<BatchItemResponse> items = inboundBatchItemsRepository.getItemsByBatchId(group.getBatchId());
            group.setBatchItems(items);
        }
        return groups;
    }

    @Override
    public BatchStatsResponse getBatchStats() {
        long activeBatches = inboundBatchItemsRepository.countRealActiveBatches();
        LocalDate today = LocalDate.now();
        LocalDate threeDaysLater = today.plusDays(3);
        long expiringBatches = inboundBatchItemsRepository.countExpiringSoonLotes(today, threeDaysLater);
        long liquidatedLots = inboundBatchItemsRepository.countLiquidatedLots();
        return new BatchStatsResponse(activeBatches, expiringBatches, liquidatedLots);
    }
}