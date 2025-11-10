from databricks.sdk import WorkspaceClient
from databricks.sdk.service.jobs import Task, NotebookTask, Source, JobCluster
from databricks.sdk.service.compute import ClusterSpec, Kind

POOL_ID = "1110-145209-elude6-pool-nbeyemqr"

workspace = WorkspaceClient(profile="default")

# Driver with n workers
# job_compute = ClusterSpec(
#    spark_version="16.4.x-scala2.12",
#    instance_pool_id=POOL_ID,
#    driver_instance_pool_id=POOL_ID,
#    num_workers=1
# )

# Single node
job_compute = ClusterSpec(
    spark_version="16.4.x-scala2.12",
    instance_pool_id=POOL_ID,
    is_single_node=True,
    kind=Kind.CLASSIC_PREVIEW,
)

job_cluster = JobCluster(
    job_cluster_key="single_node_pool_cluster", new_cluster=job_compute
)

job = workspace.jobs.create(
    name="instance_pool_notebook_job",
    tasks=[
        Task(
            description="Test for multiple job clusters with instance pools",
            job_cluster_key=job_cluster.job_cluster_key,
            notebook_task=NotebookTask(
                notebook_path="/Workspace/Shared/sandbox", source=Source("WORKSPACE")
            ),
            task_key="run_notebook_task",
        )
    ],
    job_clusters=[job_cluster],
)

run = workspace.jobs.run_now(job_id=job.job_id)
run_id = run.run_id
print(run_id)
