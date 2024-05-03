class SoccerMatch {
  League league;
  Team home;
  Team away;
  SoccerMatch({required this.league, required this.home, required this.away});
}

class Team {
  String image;
  String name;
  String goal;

  Team({required this.image, required this.name, required this.goal});
}

class League {
  String image;
  String name;
  League({required this.image, required this.name});
}
