import numpy as np
import pandas as pd
from arcpy import ListDatasets, ListFeatureClasses, env, metadata as md  # NOQA        <- se isso engatilhar "RuntimeError", possivelmente é falta de "product license has not been initialized, logar no ArcGIS
import xml.etree.ElementTree as ET  # NOQA
from decorators import singleton


class Element2Update:
    def __init__(self, name, xpath, column_name, to_duplicate):
        self.name = name
        self.xpath = xpath
        self.column_name = column_name
        self.to_duplicate = to_duplicate


@singleton
class XmlElements:
    def __init__(self):
        self.elements = []

    def add(self, element2update):
        self.elements.append(element2update)

    def get(self, name):
        for element in self.elements:
            if element.name == name:
                return element
        return None

    def name_them(self):
        print('These are the elements:')
        print([element.name for element in self.elements])
        return None


el = XmlElements()
el.add(Element2Update(name='resTitle', xpath='.//dataIdInfo/idCitation/resTitle', column_name='Título - METADADO - Final', to_duplicate=False))
el.name_them()


element2update = {
    'resTitle':
        ('.//dataIdInfo/idCitation/resTitle',
         'Título - METADADO - Final',
         False),
    'createDate':
        ('.//dataIdInfo/idCitation/date/createDate',
         'ano',
         False),
    'idCredit':
        ('.//dataIdInfo/idCredit',
         'Crédito (Instituição fonte)',
         False),
    'TopicCatCd':
        ('.//dataIdInfo/tpCat/TopicCatCd',
         'Cód. Categoria temática',
         False),
    'idAbs':
        ('.//dataIdInfo/idAbs',
         'Descrição',
         False),
    'Tags - keyword':
        ('.//dataIdInfo/searchKeys/keyword',
         'Tags',
         False),
    # DataDosMetadados
    'idPurp':
        ('.//dataIdInfo/idPurp',
         'Resumo (sumário)',
         False),
    'Linhagem - statement':
        ('.//dqInfo/dataLineage/statement',
         'Linhagem',
         False),
    'languageCode':
        ('.//dataIdInfo/dataLang/languageCode',
         'Idioma',
         False),
    'mdLang':
        ('.//mdLang/languageCode',
         'Idioma dos metadados',
         False),
    'formatName':
        ('.//distInfo/distFormat/formatName',
         'Formato distribuição',
         False),
    'DistformatVer':
        ('.//distInfo/distFormat/formatVer',
         'Formato versão',
         False),
    'identCode':
        ('.//refSysInfo/RefSystem/refSysID/identCode',
         'Código do sistema de referência',
         False),
    'idCodeSpace':
        ('.//refSysInfo/RefSystem/refSysID/idCodeSpace',
         'Tipo de código',
         False),
    'RefformatVer':
        ('.//refSysInfo/RefSystem/refSysID/idVersion',
         'Versão do tipo de código',
         False),
    # Resource.Points of Contact
    'rpIndName':
        ('.//dataIdInfo/idPoC/rpIndName',
         'Responsável pelos metadados - Nome',
         False),
    'rpOrgName':
        ('.//dataIdInfo/idPoC/rpOrgName',
         'Responsável pelos metadados - Organização',
         False),
    'rpPosName':
        ('.//dataIdInfo/idPoC/rpPosName',
         'Responsável pelos metadados - Posiçao',
         False),
    'RoleCd':
        ('.//dataIdInfo/idPoC/role/RoleCd',
         'Responsável pelos metadados - Papel na governança_COD',
         False),
    'MaintFreqCd':
        ('.//dataIdInfo/resMaint/maintFreq/MaintFreqCd',
         'Frequência de manutenção_COD',
         False),
    'Status':
        ('.//dataIdInfo/idStatus/ProgCd',
         'Status_COD',
         False),
    'thumbnail_url':
        ('.//dataIdInfo/graphOver/bgFileName',
         'Thumbnail url',
         False),
    'useLimit':
        ('.//dataIdInfo/resConst/Consts/useLimit',
         'Limitação de uso',
         False),
    'equScale':
        ('.//dataIdInfo/dataScale/equScale/rfDenom',
         'Escala denominador',
         False),
    'scaleDist':
        ('.//dataIdInfo/dataScale/scaleDist/value',
         'Escala distância de resolução',
         False),
    'scale_unitOfMeasurement':
        ('.//dataIdInfo/dataScale/scaleDist/value',
         'Escala unidade de medida',
         False),
    'Data dos metadados - Date Stamp':
        ('.//mdDateSt',
         'Data dos metadados (aaaammdd)',
         False),
    'Online Access':
        ('.//distInfo/distTranOps/onLineSrc/linkage',
         'Acesso Online URL',
         False),
    'MD Encoding':
        ('.//mdChar/CharSetCd',
         'MD Encoding_COD',
         False),
    'Data Encoding':
        ('.//dataIdInfo/dataChar/CharSetCd',
         'Data Encoding_COD',
         False),
    # DataExt - GeoBndBox
    'GeoBndBox - westBL':
        ('.//dataIdInfo/dataExt/geoEle/GeoBndBox/westBL',
         'GeoBndBox - westBL',
         False),
    'GeoBndBox - eastBL':
        ('.//dataIdInfo/dataExt/geoEle/GeoBndBox/eastBL',
         'GeoBndBox - eastBL',
         False),
    'GeoBndBox - southBL':
        ('.//dataIdInfo/dataExt/geoEle/GeoBndBox/southBL',
         'GeoBndBox - southBL',
         False),
    'GeoBndBox - northBL':
        ('.//dataIdInfo/dataExt/geoEle/GeoBndBox/northBL',
         'GeoBndBox - northBL',
         False),
    'GeoBndBox - exTypeCode':
        ('.//dataIdInfo/dataExt/geoEle/GeoBndBox/exTypeCode',
         'GeoBndBox - exTypeCode',
         False),
    # DataExt - vertEle
    'vertEle - vertMinVal':
        ('.//dataIdInfo/dataExt/vertEle/vertMinVal',
         'vertEle - vertMinVal',
         False),
    'vertEle - vertMaxVal':
        ('.//dataIdInfo/dataExt/vertEle/vertMaxVal',
         'vertEle - vertMaxVal',
         False),
    # DataExt - tempEle - TM_period
    'tempEle - tmBegin':
        ('.//dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Period/tmBegin',
         'tempEle - tmBegin',
         False),
    'tempEle - tmEnd':
        ('.//dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Period/northBL',
         'tempEle - tmEnd',
         False),
    # DataExt - tempEle - TM_instant
    'tempEle - tmPosition':
        ('.//dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Instant/tmPosition',
         'tempEle - tmPosition',
         False),
    'mdFileID':
        ('.//mdFileID',
         'id',
         False)
}

df = pd.DataFrame(columns=['Camada_enterprise', 'Dataset_script'])

env.overwriteOutput = True
env.workspace = r'Q:\DADOS\0_PROCESSAMENTO_CODEX\00_GDB\20233101_BKP_BD_ENTERPRISE.gdb'


i = 0
for dt in ListDatasets(feature_type='feature'):
    for fc in ListFeatureClasses(feature_dataset=dt):
        if i > 10: break
        ft_path = fr'{dt}\{fc}'

        # Connect to Feature's Metadata
        metadata = md.Metadata(ft_path)

        # Get Metadata as xml
        root = ET.fromstring(metadata.xml)

        print(i + 1, dt, fc)
        df.loc[i, 'Camada_enterprise'] = fc
        df.loc[i, 'Dataset_script'] = dt
        for k, v in element2update.items():
            xpath, column, _ = v
            found = root.find(xpath)
            if found is not None:
                text = found.text
                # if tags, iterar entre filhos
                if column == 'Tags':
                    nodes = root.findall(xpath)
                    text = []
                    for node in nodes:
                        text.append(node.text)
                    text = str(text)[1:-1].replace("'", "")
                try:
                    df.loc[i, column] = text
                except KeyError:
                    df[column] = np.nan
                    df.loc[i, column] = text
            else:
                try:
                    df.loc[i, column] = ""
                except KeyError:
                    df[column] = np.nan
                    df.loc[i, column] = ""
        i += 1
print(df['Tags'])
df.to_excel('metadados_lidos.xlsx')
