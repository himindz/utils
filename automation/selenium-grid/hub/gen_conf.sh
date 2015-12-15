#!/bin/bash

echo "
{
  \"host\": null,
  \"port\": 4444,
  \"prioritizer\": null,
  \"capabilityMatcher\": \"org.openqa.grid.internal.utils.DefaultCapabilityMatcher\",
  \"throwOnCapabilityNotPresent\": true,
  \"newSessionWaitTimeout\": $GRID_NEW_SESSION_WAIT_TIMEOUT,
  \"jettyMaxThreads\": $GRID_JETTY_MAX_THREADS,
  \"nodePolling\": $GRID_NODE_POLLING,
  \"cleanUpCycle\": $GRID_CLEAN_UP_CYCLE,
  \"timeout\": $GRID_TIMEOUT,
  \"browserTimeout\": $GRID_BROWSER_TIMEOUT,
  \"maxSession\": $GRID_MAX_SESSION,
  \"unregisterIfStillDownAfter\": $GRID_UNREGISTER_IF_STILL_DOWN_AFTER
}" 


