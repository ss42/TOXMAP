//
//  Chemical.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import Foundation


class Chemical {
    let chemicalName: String?
    let chemicalID: String?
    let chemicalCASNum: String?
    
    init(chemicalName: String, chemicalID: String, chemicalCASNum: String){
        self.chemicalID = chemicalID
        self.chemicalName = chemicalName
        self.chemicalCASNum = chemicalCASNum
    }
    
    
}
struct ChemicalList {
    //static let list = []
    let chemicalTable: [String:String] =
        [ // key:value
            "Asbestos (friable)":"CHEM_1",
            "Benzene":"CHEM_2",
            "Chromium Compounds":"CHEM_3",
            "Ethylene Oxide":"CHEM_4",
            "Formaldehyde":"CHEM_5",
            "Lead":"CHEM_6",
            "Lead Compounds":"CHEM_7",
            "Mercury":"CHEM_8",
            "Mercury Compounds":"CHEM_9",
            "Nickel Compounds":"CHEM_10"
    ]
    static let chemicalName = ["1,1,1,2-Tetrachloro-2-fluoroethane","1,1,1,2-Tetrachloroethane","1,2-Dibromo-3-chloropropane","2-Acetylaminofluorene","3,3'-Dichlorobenzidine","3,3'-Dichlorobenzidine dihydrochloride","3,3'-Dichlorobenzidine sulfate","4,4'-Isopropylidenediphenol","4,4'-Methylenebis(2-chloroaniline)","4,4'-Methylenedianiline","4,6-Dinitro-o-cresol","4-Aminobiphenyl","4-Dimethylaminoazobenzene","Abamectin","Acetaldehyde","Acetone","Acrolein","Acrylonitrile","Aldicarb","Aldrin","Aluminum phosphide","Ammonia","Arsenic","Arsenic compounds","Asbestos (friable)","Benomyl","Benzene","Benzidine","Benzo(g,h,i)perylene","Beryllium","Beryllium compounds","beta-Naphthylamine","beta-Propiolactone","Bis(chloromethyl) ether","Bromoxynil","C.I. Direct Black 38","Cadmium","Cadmium compounds","Carbofuran","Chlordane","Chlorine","Chloromethyl methyl ether","Chloropicrin","Chlorothalonil","Chromium","CHEM_45","Chromium compounds(except chromite ore mined in the transvaal region)","Copper","Creosote","Cyfluthrin","Dichloromethane","Dichlorvos","Dimethyl phthalate","Dioxin and dioxin-like compounds","Ethoprop","Ethylene","Ethylene glycol","Ethylene oxide","Fenbutatin oxide","Fenpropathrin","Formaldehyde","Freon 113","Heptachlor","Hexachlorobenzene","Hydrogen sulfide","Isodrin","Lead","Lead compounds","Lindane","Mercury","Mercury compounds","Methanol","Methoxychlor","Methyl parathion","Mevinphos","Mustard gas","Naphthalene","Nickel compounds","N-Nitrosodimethylamine","Octachlorostyrene","o-Toluidine","Ozone","Paraquat dichloride","Parathion","Pendimethalin","Pentachlorobenzene","Pentachlorophenol","Phosphine","Phosphorus","Polychlorinated biphenyls","Polycyclic aromatic compounds","Propylene oxide","Sodium fluoroacetate","Styrene","Tetrabromobisphenol A","Toluene","Toluene diisocyanate (mixed isomers)","Toxaphene","trans-1,3-Dichloropropene"	,"Trichloroethylene"	,"Trifluralin","Triphenyltin hydroxide","Vinyl chloride"]
    let chemicalAlias = [
        "CHEM_1","CHEM_2","CHEM_3","CHEM_4","CHEM_5","CHEM_6","CHEM_7","CHEM_8","CHEM_9","CHEM_10","CHEM_11","CHEM_12","CHEM_13","CHEM_14","CHEM_15",
        "CHEM_16","CHEM_17","CHEM_18","CHEM_19","CHEM_20","CHEM_21","CHEM_22","CHEM_23","CHEM_24","CHEM_25","CHEM_26","CHEM_27","CHEM_28","CHEM_29","CHEM_30","CHEM_31",
        "CHEM_32","CHEM_33","CHEM_34","CHEM_35","CHEM_36","CHEM_37","CHEM_38","CHEM_39","CHEM_40","CHEM_41","CHEM_42","CHEM_43","CHEM_44","CHEM_45","CHEM_46",
        "CHEM_47","CHEM_48","CHEM_49","CHEM_50","CHEM_51","CHEM_52","CHEM_53","CHEM_54","CHEM_55","CHEM_56","CHEM_57","CHEM_58","CHEM_59","CHEM_60","CHEM_61",
        "CHEM_62","CHEM_63","CHEM_64","CHEM_65","CHEM_66","CHEM_67","CHEM_68","CHEM_69","CHEM_70","CHEM_71","CHEM_72","CHEM_73","CHEM_74","CHEM_75","CHEM_76",
        "CHEM_77","CHEM_78","CHEM_79","CHEM_80","CHEM_81","CHEM_82","CHEM_83","CHEM_84","CHEM_85","CHEM_86","CHEM_87","CHEM_88","CHEM_89","CHEM_90","CHEM_91",
        "CHEM_92","CHEM_93","CHEM_94","CHEM_95","CHEM_96","CHEM_97","CHEM_98","CHEM_99","CHEM_100","CHEM_101","CHEM_102"
    ]
    let chemicalCAS = [
        "630-20-6",
        "96-12-8",
        "53-96-3",
        "91-94-1",
        "612-83-9",
        "64969-34-2",
        "80-05-7",
        "101-14-4",
        "101-77-9",
        "534-52-1",
        "92-67-1",
        "60-11-7",
        "71751-41-2",
        "75-07-0",
        "67-64-1",
        "107-02-8",
        "107-13-1",
        "116-06-3",
        "309-00-2",
        "20859-73-8",
        "7764-41-7",
        "7440-38-2",
        "N020",
        "1332-21-4",
        "17804-35-2",
        "71-43-2",
        "92-87-5",
        "191-24-2",
        "7440-41-7",
        "N050",
        "91-59-8",
        "57-57-8",
        "542-88-1",
        "1689-84-5",
        "1937-37-7",
        "7440-43-9",
        "N078",
        "1563-66-2",
        "57-74-9",
        "7782-50-5",
        "107-30-2",
        "76-06-2",
        "1897-45-6",
        "7440-47-3",
        "N090",
        "7440-50-8",
        "8001-58-9",
        "68359-37-5",
        "75-09-2",
        "62-73-7",
        "131-11-3",
        "N150",
        "13194-48-4",
        "74-85-1",
        "107-21-1",
        "75-21-8",
        "13356-08-6",
        "39515-41-8",
        "50-00-0",
        "76-13-1",
        "76-44-8",
        "118-74-1",
        "7783-06-4",
        "465-73-6",
        "7439-92-1",
        "N420",
        "58-89-9",
        "7439-97-6",
        "N458",
        "67-56-1",
        "72-43-5",
        "298-00-0",
        "7786-34-7",
        "505-60-2",
        "91-20-3",
        "N495",
        "62-75-9",
        "29082-74-4",
        "95-53-4",
        "10028-15-6",
        "1910-42-5",
        "56-38-2",
        "40487-42-1",
        "608-93-5",
        "87-86-5",
        "7803-51-2",
        "7723-14-0",
        "1336-36-3",
        "N590",
        "75-56-9",
        "62-74-8",
        "100-42-5",
        "79-94-7",
        "108-88-3",
        "26471-62-5",
        "8001-35-2",
        "10061-02-6",
        "79-01-6",
        "1582-09-8",
        "76-87-9",
        "75-01-4"
    ]
}
