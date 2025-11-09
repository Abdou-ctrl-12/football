--DIMENSION TABLES
-- DIM_DATE
CREATE TABLE dim_date (
  date_id DATE PRIMARY KEY,
  day NUMBER,
  month NUMBER,
  year NUMBER,
  week NUMBER,
  quarter NUMBER,
  season VARCHAR2(20)
);

-- DIM_COMPETITION
CREATE TABLE dim_competition (
  competition_id NUMBER PRIMARY KEY,
  competition_name VARCHAR2(100)
);

-- DIM_TEAM
CREATE TABLE dim_team (
  team_id NUMBER PRIMARY KEY,
  team_name_std VARCHAR2(100),
  team_name_gps VARCHAR2(100),
  team_name_wyscout VARCHAR2(100),
  has_gps CHAR(1),
  has_wyscout CHAR(1)
);

-- DIM_PLAYER
CREATE TABLE dim_player (
  player_id NUMBER PRIMARY KEY,
  player_name_std VARCHAR2(100),
  player_name_gps VARCHAR2(100),
  player_name_wyscout VARCHAR2(100),
  has_gps CHAR(1),
  has_wyscout CHAR(1)
);

-- DIM_MATCH
CREATE TABLE dim_match (
  match_id NUMBER PRIMARY KEY,
  match_date DATE,
  home_team_id NUMBER REFERENCES dim_team(team_id),
  away_team_id NUMBER REFERENCES dim_team(team_id),
  competition_id NUMBER REFERENCES dim_competition(competition_id),
  score_home NUMBER,
  score_away NUMBER
);
--FACT TABLES
-- FACT_PLAYER_GPS
CREATE TABLE fact_player_gps (
  gps_id NUMBER PRIMARY KEY,
  player_id NUMBER REFERENCES dim_player(player_id),
  team_id NUMBER REFERENCES dim_team(team_id),
  match_id NUMBER REFERENCES dim_match(match_id),
  date_id DATE REFERENCES dim_date(date_id),
  session_type VARCHAR2(20), -- 'match' or 'training'
  distance_covered NUMBER,
  top_speed NUMBER,
  accelerations NUMBER,
  decelerations NUMBER,
  load NUMBER
  -- Add more GPS metrics as needed
);

-- FACT_WYSCOUT_MATCH
CREATE TABLE fact_wyscout_match (
  wyscout_match_id NUMBER PRIMARY KEY,
  match_id NUMBER REFERENCES dim_match(match_id),
  team_id NUMBER REFERENCES dim_team(team_id),
  opponent_team_id NUMBER REFERENCES dim_team(team_id),
  competition_id NUMBER REFERENCES dim_competition(competition_id),
  date_id DATE REFERENCES dim_date(date_id),
  possession_pct NUMBER,
  xg NUMBER,
  shots_total NUMBER,
  shots_on_target NUMBER,
  passes_total NUMBER,
  passes_precise NUMBER
  -- Add more tactical metrics as needed
);

-- FACT_WYSCOUT_PLAYER
CREATE TABLE fact_wyscout_player (
  wyscout_player_id NUMBER PRIMARY KEY,
  player_id NUMBER REFERENCES dim_player(player_id),
  team_id NUMBER REFERENCES dim_team(team_id),
  match_id NUMBER REFERENCES dim_match(match_id),
  competition_id NUMBER REFERENCES dim_competition(competition_id),
  date_id DATE REFERENCES dim_date(date_id),
  minutes_played NUMBER,
  goals NUMBER,
  xg NUMBER,
  passes_total NUMBER,
  passes_precise NUMBER,
  duels_won NUMBER,
  goalkeeper_saves NUMBER -- NULL for outfield players
  -- Add more player metrics as needed
);