import { defineRailway, project, service } from "railway/iac";

// finance-cash-flow-api: the Cash flow cell. Variables stay unmanaged (secrets live in Railway only).
// cash-flow-api sleeps when idle (Railway Serverless) and wakes on the next request.
// Every service runs in Singapore next to Neon (aws-ap-southeast-1) and empire-platform; the IaC does not
// carry the region, so after the first deploy: railway scale --service <svc> asia-southeast1-eqsg3a=1 us-east4-eqdc4a=0
export default defineRailway(() => {
  const api = service("cash-flow-api", {
    healthcheck: "/health",
    healthcheckTimeout: 60,
    deploy: { sleepApplication: true },
  });

  return project("finance-cash-flow-api", {
    variables: { managed: false },
    resources: [api],
  });
});
