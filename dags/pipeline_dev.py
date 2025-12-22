from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator


def say_hello(**context):
    print("Hello, Airflow!")
    print(f"Execution date: {context['ds']}")
    print("DAG is running correctly.")


with DAG(
    dag_id="hello_airflow",
    description="Simple DAG to validate Airflow setup",
    start_date=datetime(2025, 1, 1),
    schedule="*/1 * * * *",  # a cada 1 minuto
    catchup=False,
    tags=["test", "dev"],
) as dag:

    hello_task = PythonOperator(
        task_id="say_hello",
        python_callable=say_hello,
    )

    hello_task
