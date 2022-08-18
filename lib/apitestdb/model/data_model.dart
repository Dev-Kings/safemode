import 'dart:convert';

List<Data> dataFromJson(String string) =>
    List<Data>.from(json.decode(string).map((x) => Data.fromJson(x)));

String dataToJson(List<Data> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Data {
  final int? id;
  int qamonitorId;
  int userId;
  int varietyId;
  int quantityChecked;
  int totalMistakes;
  int cuttingsTooThick;
  int cuttingsTooThin;
  int cuttingsTooLong;
  int cuttingsTooShort;
  int cuttingsTooHard;
  int cuttingsTooSoft;
  int moreLeaves;
  int lessLeaves;
  int longPetiole;
  int shortPetiole;
  int overmatureCuttings;
  int immatureCuttings;
  int shortStickingLength;
  int damagedLeaf;
  int mechanicalDamage;
  int diseaseDamage;
  int insectDamage;
  int chemicalDamage;
  int heelLeaf;
  int mutation;
  int blindShoots;
  int buds;
  int poorHormoning;
  int unevenCut;
  int overgrading;
  int poorPacking;
  int overcount;
  int undercount;
  int bigLeaves;
  int smallLeaves;
  int bigCuttings;
  int smallCuttings;
  String createdAt;

  Data({
    this.id,
    required this.qamonitorId,
    required this.userId,
    required this.varietyId,
    required this.quantityChecked,
    required this.totalMistakes,
    required this.cuttingsTooThick,
    required this.cuttingsTooThin,
    required this.cuttingsTooLong,
    required this.cuttingsTooShort,
    required this.cuttingsTooHard,
    required this.cuttingsTooSoft,
    required this.moreLeaves,
    required this.lessLeaves,
    required this.longPetiole,
    required this.shortPetiole,
    required this.overmatureCuttings,
    required this.immatureCuttings,
    required this.shortStickingLength,
    required this.damagedLeaf,
    required this.mechanicalDamage,
    required this.diseaseDamage,
    required this.insectDamage,
    required this.chemicalDamage,
    required this.heelLeaf,
    required this.mutation,
    required this.blindShoots,
    required this.buds,
    required this.poorHormoning,
    required this.unevenCut,
    required this.overgrading,
    required this.poorPacking,
    required this.overcount,
    required this.undercount,
    required this.bigLeaves,
    required this.smallLeaves,
    required this.bigCuttings,
    required this.smallCuttings,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        qamonitorId: json['qamonitor_id'],
        userId: json['user_id'],
        varietyId: json['variety_id'],
        quantityChecked: json['quantity_checked'],
        totalMistakes: json['total_mistakes'],
        cuttingsTooThick: json['cuttings_too_thick'],
        cuttingsTooThin: json['cuttings_too_thin'],
        cuttingsTooLong: json['cuttings_too_long'],
        cuttingsTooShort: json['cuttings_too_short'],
        cuttingsTooHard: json['cuttings_too_hard'],
        cuttingsTooSoft: json['cuttings_too_soft'],
        moreLeaves: json['more_leaves'],
        lessLeaves: json['less_leaves'],
        longPetiole: json['long_petiole'],
        shortPetiole: json['short_petiole'],
        overmatureCuttings: json['overmature_cuttings'],
        immatureCuttings: json['immature_cuttings'],
        shortStickingLength: json['short_sticking_length'],
        damagedLeaf: json['damaged_leaf'],
        mechanicalDamage: json['mechanical_damage'],
        diseaseDamage: json['disease_damage'],
        insectDamage: json['insect_damage'],
        chemicalDamage: json['chemical_damage'],
        heelLeaf: json['heel_leaf'],
        mutation: json['mutation'],
        blindShoots: json['blind_shoots'],
        buds: json['buds'],
        poorHormoning: json['poor_hormoning'],
        unevenCut: json['uneven_cut'],
        overgrading: json['overgrading'],
        poorPacking: json['poor_packing'],
        overcount: json['overcount'],
        undercount: json['undercount'],
        bigLeaves: json['big_leaves'],
        smallLeaves: json['small_leaves'],
        bigCuttings: json['big_cuttings'],
        smallCuttings: json['small_cuttings'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qamonitor_id": qamonitorId,
        "user_id": userId,
        "variety_id": varietyId,
        "quantity_checked": quantityChecked,
        "total_mistakes": totalMistakes,
        "cuttings_too_thick": cuttingsTooThick,
        "cuttings_too_thin": cuttingsTooThin,
        "cuttings_too_long": cuttingsTooLong,
        "cuttings_too_short": cuttingsTooShort,
        "cuttings_too_hard": cuttingsTooHard,
        "cuttings_too_soft": cuttingsTooSoft,
        "more_leaves": moreLeaves,
        "less_leaves": lessLeaves,
        "long_petiole": longPetiole,
        "short_petiole": shortPetiole,
        "overmature_cuttings": overmatureCuttings,
        "immature_cuttings": immatureCuttings,
        "short_sticking_length": shortStickingLength,
        "damaged_leaf": damagedLeaf,
        "mechanical_damage": mechanicalDamage,
        "disease_damage": diseaseDamage,
        "insect_damage": insectDamage,
        "chemical_damage": chemicalDamage,
        "heel_leaf": heelLeaf,
        "mutation": mutation,
        "blind_shoots": blindShoots,
        "buds": buds,
        "poor_hormoning": poorHormoning,
        "uneven_cut": unevenCut,
        "overgrading": overgrading,
        "poor_packing": poorPacking,
        "overcount": overcount,
        "undercount": undercount,
        "big_leaves": bigLeaves,
        "small_leaves": smallLeaves,
        "big_cuttings": bigCuttings,
        "small_cuttings": smallCuttings,
        "created_at": createdAt,
      };

  Map<String, dynamic> toMap() {
    return {
        "id": id,
        "qamonitor_id": qamonitorId,
        "user_id": userId,
        "variety_id": varietyId,
        "quantity_checked": quantityChecked,
        "total_mistakes": totalMistakes,
        "cuttings_too_thick": cuttingsTooThick,
        "cuttings_too_thin": cuttingsTooThin,
        "cuttings_too_long": cuttingsTooLong,
        "cuttings_too_short": cuttingsTooShort,
        "cuttings_too_hard": cuttingsTooHard,
        "cuttings_too_soft": cuttingsTooSoft,
        "more_leaves": moreLeaves,
        "less_leaves": lessLeaves,
        "long_petiole": longPetiole,
        "short_petiole": shortPetiole,
        "overmature_cuttings": overmatureCuttings,
        "immature_cuttings": immatureCuttings,
        "short_sticking_length": shortStickingLength,
        "damaged_leaf": damagedLeaf,
        "mechanical_damage": mechanicalDamage,
        "disease_damage": diseaseDamage,
        "insect_damage": insectDamage,
        "chemical_damage": chemicalDamage,
        "heel_leaf": heelLeaf,
        "mutation": mutation,
        "blind_shoots": blindShoots,
        "buds": buds,
        "poor_hormoning": poorHormoning,
        "uneven_cut": unevenCut,
        "overgrading": overgrading,
        "poor_packing": poorPacking,
        "overcount": overcount,
        "undercount": undercount,
        "big_leaves": bigLeaves,
        "small_leaves": smallLeaves,
        "big_cuttings": bigCuttings,
        "small_cuttings": smallCuttings,
        "created_at": createdAt,
    };
  }
}
