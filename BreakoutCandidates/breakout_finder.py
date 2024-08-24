import pandas as pd

df = pd.read_csv('.../BreakoutCandidates/Data/(POSITION) Results/(POSITION)_adp.csv')
top__categories = ['...'] # Metrics that should be in the top percentile
bottom__categories = ['...'] # Metrics that should be in the bottom percentile

def predict_breakout_players(dataframe, year, top__categories, bottom__categories):
    df_year = dataframe[dataframe['year'] == year]

    thresholds = {}
    for category in top__categories:
        thresholds[category] = df_year[category].quantile(0.50)
    for category in bottom__categories:
        thresholds[category] = df_year[category].quantile(0.50)

    conditions = []
    for category in top__categories:
        conditions.append(df_year[category] >= thresholds[category])

    for category in bottom__categories:
        conditions.append(df_year[category] <= thresholds[category])

    df_year['Breakout_Predict'] = pd.concat(conditions, axis=1).all(axis=1)
    breakout_players = df_year[df_year['Breakout_Predict'] == True]

    return breakout_players[['Player', 'year'] + top__categories + bottom__categories]

predicted_breakout_players = predict_breakout_players(df, 2023, top__categories, bottom__categories)

print(predicted_breakout_players)
