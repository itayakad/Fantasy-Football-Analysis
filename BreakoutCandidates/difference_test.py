import pandas as pd

breakout_df = pd.read_csv('.../BreakoutCandidates/Data/(POSITION) Results/(POSITION)_pre_breakout.csv')
adp_df = pd.read_csv('.../BreakoutCandidates/Data/(POSITION) Results/(POSITION)_adp.csv')

# Filter uselss columns
breakout_df = breakout_df.drop(columns=['Player', 'year', 'breakout_score'])
adp_df = adp_df.drop(columns=['Player', 'year'])
numeric_columns_breakout = breakout_df.select_dtypes(include=['number']).columns
numeric_columns_adp = adp_df.select_dtypes(include=['number']).columns

common_numeric_columns = numeric_columns_breakout.intersection(numeric_columns_adp)
breakout_averages = breakout_df[common_numeric_columns].mean()
normal_averages = adp_df[common_numeric_columns].mean()

percentage_diff = (breakout_averages - normal_averages) / normal_averages * 100

results_df = pd.DataFrame({
    'pre_breakout_avg': breakout_averages,
    'normal_avg': normal_averages,
    'percentage_diff': percentage_diff
}).sort_values(by='percentage_diff', ascending=False)

print(results_df)
