require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  test 'Teacher.all_remote must not be nil' do
    # Teacher.expects(:from_site).with('teacher', 'Teacher', nil, 0, nil, nil).returns(
    #     [Teacher.new, Teacher.new]
    # ) if ENV['MOCK']
    Net::HTTP.expects(:get).with(URI("#{Teacher.site}?type=teacher&id=&where=&limit=0&order=")).returns(
        '[{}]'
    )
    teachers = Teacher.all
    assert_not_nil teachers
  end

  test 'The first teacher in the array must by named DOCENTE UNO' do
    # Teacher.expects(:from_site).with('teacher', 'Teacher', nil, 1, nil, nil).returns(
    #     [Teacher.new(last_name: 'DOCENTE', first_name: 'UNO')]
    # ) if ENV['MOCK']

    Net::HTTP.expects(:get).with(URI("#{Teacher.site}?type=teacher&id=&where=&limit=1&order=")).returns(
        '[{"last_name": "DOCENTE", "first_name": "UNO"}]'
    ) if ENV['MOCK']

    teacher = Teacher.first
    assert_equal 'DOCENTE', teacher.last_name
    assert_equal 'UNO', teacher.first_name
  end

  test 'Teacher.where(\'ENABLED eq 1\') must return at least one teacher' do
    # Teacher.expects(:from_site).with('teacher', 'Teacher', nil, 0, 'ENABLED eq 1', nil).returns(
    #     [Teacher.new()]
    # ) if ENV['MOCK']
    Net::HTTP.expects(:get).with(URI("#{Teacher.site}?type=teacher&id=&where=ENABLED%20eq%201&limit=0&order=")).returns(
        '[{"last_name": "DOCENTE", "first_name": "UNO"}]'
    ) if ENV['MOCK']

    teachers = Teacher.where('ENABLED eq 1')
    assert_not_nil teachers
    assert_operator teachers.count, :>, 0
  end

  test 'Ordering Teachers by last_name and first_name' do
    # Teacher.expects(:from_site).with('teacher', 'Teacher', nil, 0, nil, 'COGNOME_RAGSOC, NOME').returns(
    #     [Teacher.new(last_name: 'A'), Teacher.new(last_name: 'B')]
    # ) if ENV['MOCK']
    Net::HTTP.expects(:get).with(URI("#{Teacher.site}?type=teacher&id=&where=&limit=0&order=COGNOME_RAGSOC,%20NOME")).returns(
        '[{"last_name": "A"},{"last_name": "B"}]'
    ) if ENV['MOCK']

    teachers = Teacher.order('COGNOME_RAGSOC, NOME')
    assert (teachers[0].last_name < teachers[1].last_name), 'Order not satisfied'
  end
end