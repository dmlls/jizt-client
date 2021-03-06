import 'package:domain/domain.dart';
import 'package:jizt_api/jizt_api.dart';
import 'package:jizt_repository/src/mapper/dto/summary_model_model_to_dto_mapper.dart';
import 'package:jizt_repository/src/mapper/dto/summary_params_model_to_dto_mapper.dart';
import 'package:jizt_repository/src/mapper/mapper.dart';

class SummaryRequestModelToDtoMapper
    extends Mapper<SummaryRequest, SummaryRequestDto> {
  @override
  SummaryRequestDto map(SummaryRequest input) {
    return SummaryRequestDto(
      source: input.source,
      model: input.model != null
          ? SummaryModelModelToDtoMapper().map(input.model)
          : null,
      params: input.params != null
          ? SummaryParamsModelToDtoMapper().map(input.params)
          : null,
    );
  }
}
