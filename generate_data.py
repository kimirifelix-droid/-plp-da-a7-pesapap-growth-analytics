import numpy as np
import pandas as pd

rng = np.random.default_rng(77)

users = pd.DataFrame({
    "user_id": range(1, 3001),
    "signup_date": (
        pd.to_datetime("2026-01-01")
        + pd.to_timedelta(rng.integers(0, 120, 3000), unit="D")
    ).strftime("%Y-%m-%d"),
    "county": rng.choice(
        ["Nairobi", "Mombasa", "Kisumu", "Nakuru", "Eldoret"],
        3000
    ),
    "acquisition_channel": rng.choice(
        ["Referral", "Social", "Agent", "Search"], 3000
    ),
})

m = 12000

txns = pd.DataFrame({
    "txn_id": range(1, m + 1),
    "user_id": rng.integers(1, 3001, m),
    "txn_date": (
        pd.to_datetime("2026-01-15")
        + pd.to_timedelta(rng.integers(0, 150, m), unit="D")
    ).strftime("%Y-%m-%d"),
    "product": rng.choice(
        ["Airtime", "Bill Pay", "Send Money", "Merchant Pay"],
        m,
        p=[0.3, 0.2, 0.35, 0.15]
    ),
    "amount": rng.lognormal(6.8, 0.9, m).round(0),
})

experiment = pd.DataFrame({
    "user_id": range(1, 3001),
    "group": rng.choice(["A", "B"], 3000)
})

is_b = experiment["group"] == "B"

experiment["converted"] = np.where(
    is_b,
    rng.random(3000) < 0.14,
    rng.random(3000) < 0.11
).astype(int)

users.to_csv("users.csv", index=False)
txns.to_csv("transactions.csv", index=False)
experiment.to_csv("experiment.csv", index=False)

print("PesaPap dataset generated successfully.")
print(f"Users: {len(users):,}")
print(f"Transactions: {len(txns):,}")
print(f"Experiment assignments: {len(experiment):,}")
print("Files: users.csv, transactions.csv, experiment.csv")
